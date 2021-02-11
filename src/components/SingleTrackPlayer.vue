<template>
  <audio :key="randomForAudioTagKey" ref="tag" :controls="controls"></audio>
</template>

<script>
import ytdl from "ytdl-core";

export default {
  name: "SingleTrackPlayer",
  props: {
    controls: {
      default: true,
      type: Boolean
    },
    customId: {
      default: null
    },
    dlChunkSize: {
      default: 1024 * 1024,
      type: Number
    },
    ytVideoId: {
      type: String
    },
    preload: {
      default: true,
      type: Boolean
    },
    autoplay: {
      default: false,
      type: Boolean
    },
    transitionDuration: {
      default: 5,
      type: Number
    },
    quality: {
      default: 'highestaudio',
      type: String,
      description: 'Choose highestaudio, lowestaudio, or itag. As seen here https://github.com/fent/node-ytdl-core#ytdlchooseformatformats-options'
    }
  },
  cachedVideoId: '',
  data: function () {
    return this.initialState()
  },
  methods: {
    getCustomId() {
      return this.customId
    },
    getAudio() {
      return this.audio
    },
    initialState() {
      return {
        playRequested: this.autoplay,
        mediaSource: null,
        sourceBuffer: null,
        mimeCodec: null,
        audio: null,
        totalDurationSeconds: 0,
        baseOpts: null,
        bytesFetched: 0,
        audioContentLength: null,
        segmentDuration: null,
        totalSegments: null,
        nowFetchingSegment: false,
        fetchedSegments: 0,
        endEmitted: false,
        dataStream: null,
        randomForAudioTagKey: Math.random()
      }
    },
    reset() {
      if (this.audio) this.audio.pause()
      if (this.audio && this.audio.src) URL.revokeObjectURL(this.audio.src)
      Object.assign(this.$data, this.initialState())
    },
    doPreload() {
      if ('MediaSource' in window && MediaSource.isTypeSupported(this.mimeCodec)) {
        this.mediaSource = new MediaSource;
        this.audio.src = URL.createObjectURL(this.mediaSource);
        this.mediaSource.addEventListener('sourceopen', this.sourceOpen);
      } else {
        console.error('Unsupported MIME type or codec: ', this.mimeCodec);
      }
    },
    play() {
      if (!this.preload && !this.mediaSource) this.doPreload()
      this.playRequested = true
      if(this.audio) this.audio.play()
    },
    pause() {
      this.playRequested = false
      this.audio.pause()
    },
    sourceOpen(_) { // will be exec only once at beginning
      this.sourceBuffer = this.mediaSource.addSourceBuffer(this.mimeCodec);

      this.audio.addEventListener('play', () => {
        this.playRequested = true
        this.$emit('play', this.audio.paused)
      })
      this.audio.addEventListener('pause', () => {
        this.playRequested = false
        this.$emit('pause', this.audio.paused)
      })
      this.audio.addEventListener('timeupdate', this.checkBuffer)
      this.audio.addEventListener('timeupdate', this.checkTransitions)
      this.audio.addEventListener('timeupdate', () => this.$emit('timeupdate', this))
      this.audio.addEventListener('error', e => console.error('Audio el error', e))
      this.audio.addEventListener('seeking', this.seek);
      this.audio.addEventListener('loadedmetadata', () => {
        this.totalSegments = Math.ceil(this.audioContentLength / this.dlChunkSize)
        this.segmentDuration = this.audio.duration / this.totalSegments;
        //console.log(`[SingleTrack->loadedmetadata] Metadata loaded. Total segments: ${this.totalSegments} - segment duration: ${this.segmentDuration}`)
      });

      this.audio.addEventListener('ended', () => {
        // can also be triggered if data is not loading fast enough
        // So if there's less than a second left just call it a day
        if (this.totalDurationSeconds - this.audio.currentTime < 1) {
          if (!this.endEmitted) {
            this.$emit('ended', this)
            console.log('emitted ended after player reached eos')
          }
        }
      });

      this.audio.addEventListener('canplay', () => {
        //console.log('canplay fired')
        if (this.playRequested) this.audio.play()
      });

      this.fetchRange(this.$options.cachedVideoId, 0, this.dlChunkSize, this.appendSegment)
      if (this.autoplay) this.play()
    },
    seek(e) {
      console.log('seek', e)
      if (this.mediaSource.readyState === 'open') {
        this.sourceBuffer.abort(); // TODO do something better
        console.log(this.mediaSource.readyState);
      } else {
        console.log('seek but not open?');
        console.log(this.mediaSource.readyState);
      }
    },
    checkBuffer(_) {
      if (this.getCurrentSegment() === this.totalSegments && this.bytesFetched >= this.audioContentLength) {
        //console.log('last segment', this.mediaSource.readyState);
        this.mediaSource.endOfStream();
        this.audio.removeEventListener('timeupdate', this.checkBuffer);
      } else if (this.shouldFetchNextSegment()) {
        this.fetchRange(this.$options.cachedVideoId, this.bytesFetched, this.bytesFetched + this.dlChunkSize, this.appendSegment);
      }
    },
    checkTransitions() {
      if (this.transitionDuration > this.totalDurationSeconds - this.audio.currentTime) {
        this.audio.volume = Math.max((this.totalDurationSeconds - this.audio.currentTime) / this.transitionDuration, 0)
        if (!this.endEmitted) {
          this.endEmitted = true
          this.$emit('ending')
          setTimeout(() => {
            this.dataStream?.destroy()
            this.audio.pause()
            this.audio.removeEventListener('timeupdate', this.checkTransitions)
            this.$emit('ended', this)
          }, 1000 * this.transitionDuration)
        }
      } else if (this.audio.currentTime < this.transitionDuration) {
        this.audio.volume = this.audio.currentTime / this.transitionDuration
      } else {
        this.audio.volume = 1 // Fuck being at 98%
      }
    },
    forceEndTransition() {
      this.totalDurationSeconds = this.audio.currentTime + this.transitionDuration;
    },
    shouldFetchNextSegment() {
      // Getting away from the tutorial doing it my own way

      // console.log(`Playable time remainig: ${(this.fetchedSegments * this.segmentDuration) - this.audio.currentTime}`)
      // console.log(`Threshold: ${0.2 * this.segmentDuration}`)

      return (this.fetchedSegments * this.segmentDuration) - this.audio.currentTime < 0.2 * this.segmentDuration &&
        this.getCurrentSegment() === this.fetchedSegments &&
        !this.nowFetchingSegment
    },
    appendSegment(chunk) {
      this.sourceBuffer.appendBuffer(chunk)
    },
    fetchRange(url, start, end, cb) {
      this.nowFetchingSegment = true
      const opts = {...this.baseOpts}
      opts.range = {start, end}
      opts.dlChunkSize = 0
      this.dataStream = ytdl(url, opts)
      const chunks = []
      let startedBuffering = false

      //console.log('fetching bytes: ', start, end);

      this.sourceBuffer.onupdate = () => {
        let next = chunks.shift()
        if (next) cb(next)
      }

      this.dataStream.on('readable', function () {
        let chunk
        while (null !== (chunk = this.read())) {
          chunks.push(chunk)
        }

        if (!startedBuffering) { // start buffering while downloading
          cb(chunks.shift())
          startedBuffering = true
        }
      })

      this.dataStream.on('end', () => {
        // make sure we buffer everything
        if (!this.sourceBuffer.updating && chunks.length) cb(chunks.shift())
        // +1 because start and end are included in the stream, so we don't want to have the lower limit to dl again
        this.bytesFetched += end - start + 1
        this.fetchedSegments++
        this.nowFetchingSegment = false
        this.dataStream.destroy()
      })
    },
    getCurrentSegment() {
      return ((this.audio.currentTime / this.segmentDuration) | 0) + 1
    },
    async mountedFunction() {
      if (!this.$options.cachedVideoId) {
        return console.info('Signgletrack mounted with no video ID')
      }

      this.baseOpts = {
        filter: format => format.mimeType === 'audio/webm; codecs="opus"',
        dlChunkSize: this.dlChunkSize,
        quality: this.quality
      }

      const info = await ytdl.getInfo(this.$options.cachedVideoId, this.baseOpts)
      const format = ytdl.chooseFormat(info.formats, this.baseOpts)

      this.audio = this.$refs.tag
      this.mimeCodec = format.mimeType
      this.totalDurationSeconds = parseInt(info.videoDetails.lengthSeconds)
      this.audioContentLength = parseInt(format.contentLength)

      //console.log('[SingleTrack->mounted] Content length: ' + this.audioContentLength, 'Duration in seconds: ' + this.totalDurationSeconds)
      //console.log('[SingleTrack->mounted] Vid: ' + this.$options.cachedVideoId)
      //console.log('[SingleTrack->mounted] Format: ', format)
      //console.log('[SingleTrack->mounted] Info: ', info)

      if (this.preload) this.doPreload()
      this.audio.volume = 0
    }
  },
  mounted() {
    this.$options.cachedVideoId = this.ytVideoId
    this.mountedFunction()
  },
  beforeDestroy() {
    this.reset(false)
  },
  watch: {
    ytVideoId: async function (newv, old) {
      this.$options.cachedVideoId = newv
      //console.log('I got updated from ' + old + ' to ' + newv)
      if (this.preload && this.$options.cachedVideoId) {
        //console.log('Preloading due to prop change')
        this.reset()
        await this.mountedFunction()
      }
    }
  }
}
</script>

<style scoped>

</style>
