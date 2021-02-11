<template>
  <div>
    <div class="row">
      <div class="col" v-if="somethingToPlay">
        <q-img :src="currentVideo.bestThumbnail.url" alt="yt thumbnail" class="block q-mx-auto q-mb-md rounded-borders"/>
      </div>
      <div class="col" v-else>
        <q-img src="https://placehold.it/200x150" alt="yt thumbnail" class="block q-mx-auto q-mb-md rounded-borders"/>
      </div>
    </div>

    <div class="row">
      <div class="col" v-if="somethingToPlay">
        <div class="text-weight-bolder text-center">{{ currentVideo.title || 'No title' }}</div>
        <div class="text-center">{{ currentVideo.author.name || 'No author' }}</div>
      </div>
      <div class="col" v-else>
        There is nothing to play?
      </div>
    </div>

    <div class="row">
      <div class="col">
        <q-slider :readonly="true" :min="0" :max="sliderMax" :value="sliderValue"></q-slider>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <q-btn-group spread class="q-mr-md">
          <!--<q-btn>Previous</q-btn>-->
          <q-btn v-if="this.state === this.states.PLAYING" @click="pause" icon="pause"></q-btn>
          <q-btn v-else @click="play" icon="play_arrow"></q-btn>
          <q-btn icon="skip_next" @click="next"></q-btn>
        </q-btn-group>
      </div>
      <div class="col">
        Tracks played: {{ tracksRead }} / {{ playlist.length }}
        <q-linear-progress size="10px" :value="tracksRead / playlist.length" color="warning"/>
      </div>
    </div>

    <SingleTrackPlayer v-for="(_,playerId) in realNumberOfPlayers"
                       :custom-id="playerId"
                       :key="'player-' + playerId"
                       ref="players"
                       :controls="false"
                       :yt-video-id="getTrackIdByPlayer(playerId)"
                       :transition-duration="defaults.transitionDuration"
                       @ending="onPlayerEnding"
                       @ended="onPlayerEnded"
                       @timeupdate="onTimeUpdate"
                       @play="onPlayerPlay"
                       @pause="onPlayerPause"
    ></SingleTrackPlayer>

    <!--
    Playlist
    <div>{{ playlist.map(v => v.id) }}</div>

    Current video
    <div>{{ playlist[focusedPlayerIndex % playlist.length].id }}</div>

    Player yt ids
    <div v-for="(_,playerId) in realNumberOfPlayers">
      {{ playerId }} - {{ getTrackIdByPlayer(playerId) }}
    </div>

    -->

  </div>
</template>

<script>
import SingleTrackPlayer from "components/SingleTrackPlayer";
export default {
  name: "Player",
  components: {SingleTrackPlayer},
  props: {
    numberOfTracksToPreload: {
      default: 1,
      type: Number
    },
    playlist: {
      default: () => [],
      type: Array,
      description: 'Array of Youtube video Ids'
    },
    loopPlaylist: {
      type: Boolean, // TODO
      default: false
    },
    defaults: {
      default: () => ({
        autoplay: true,
        transitionDuration: 5
      }),
      type: Object
    }
  },
  data() {
    return {
      sliderValue: 0,
      sliderMax: 100,
      realNumberOfPlayers: Math.min(this.playlist.length, this.numberOfTracksToPreload),
      focusedPlayerIndex: 0,
      states: Object.freeze({OTHER: 0, PLAYING: 1, PAUSED: 2, BUFFERING: 4}),
      state: 0,
      tracksRead: 0,
      players: null,
    }
  },
  methods: {
    getTrackIdByPlayer(playerId) {
      if (!this.playlist.length) return
      const index = playerId + Math.ceil((this.tracksRead - playerId) / this.realNumberOfPlayers) * this.realNumberOfPlayers
      return this.playlist[index]?.id
    },
    onPlayerEnding() {
      this.focusedPlayerIndex = (this.focusedPlayerIndex+1) % this.realNumberOfPlayers
      this.sliderValue = this.defaults.transitionDuration || 0
      this.setUI()
      this.play()
    },
    onPlayerPlay(paused) {
      if (paused) this.state = this.states.PAUSED
      else this.state = this.states.PLAYING

      this.setUI()
    },
    onPlayerPause(paused) {
      if (paused) this.state = this.states.PAUSED
      else this.state = this.states.PLAYING

      this.setUI()
    },
    onPlayerEnded(player) {
      //console.log('player ended, now we must assign a new video to buffer to the one which juste ended')
      this.tracksRead++
      player.reset()
    },
    onTimeUpdate(player) {
      if (player === this.currentPlayer)
        this.sliderValue = player.getAudio().currentTime
    },
    setUI() {
      if (this.currentPlayer.getAudio())
        this.sliderMax = this.currentPlayer.getAudio().duration
    },
    next() {
      // will emit ending
      this.currentPlayer.forceEndTransition()
    },
    pause() {
      this.state = this.states.PAUSED
      this.currentPlayer.pause()
    },
    play() {
      // console.log("[Player->play] Play for player id " + this.focusedPlayerIndex)
      // console.log("[Player->play] Play for player ", this.currentPlayer.$el)
      // console.log("[Player->play] Players ", this.players.map(p => p.$el))

      if (!this.somethingToPlay) return
      this.state = this.states.PLAYING
      this.currentPlayer.play()
      this.setUI()
    }
  },
  computed: {
    bufferedVideoIds() {
      const ret = []
      for (let i = 0; i < this.realNumberOfPlayers; i++) {
        ret.push(this.playlist[(this.focusedPlayerIndex + i) % this.playlist.length])
      }
      return ret
    },
    currentPlayer() {
      return this.players[this.focusedPlayerIndex]
    },
    currentVideo() {
      return this.playlist[this.tracksRead % this.playlist.length]
    },
    somethingToPlay() {
      return this.playlist.length
    }
  },
  mounted() {
    if (!this.$refs.players) return
    this.players = this.$refs.players.map(e=>e)
    if (this.defaults.autoplay) this.play()
  }
}
</script>

<style scoped>

</style>
