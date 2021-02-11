<template>
  <div class="q-pa-lg">
<!--    <div class="row">
      <div class="col-md-3">
        3 min music track
        <q-btn @click="playTrack1">Play</q-btn>
        <q-btn @click="pauseTrack1">Pause</q-btn>
      </div>
      <div class="col">
        <SingleTrackPlayer
          ref="track1"
          yt-video-id="_wxf1nInY28"
          :dl-chunk-size="1024*1024/8"
          :preload="false"
        ></SingleTrackPlayer>
      </div>
    </div>-->


<!--    <div class="row">
      <div class="col-md-3">
        10 seconds crap
        <q-btn @click="playTrack2">Play</q-btn>
        <q-btn @click="pauseTrack2">Pause</q-btn>
      </div>
      <div class="col">
        <SingleTrackPlayer
          ref="track2"
          yt-video-id="jRWR0Ob6mLI"
          :dl-chunk-size="1024*1024/8"
          :preload="false"
        ></SingleTrackPlayer>
      </div>
    </div>-->

    <button @click="test" >test</button>
    <button @click="docopy" >copy</button>
    <input :value="body" type="text" ref="cp" />

    <div class="row">
      <div class="col">
        <!--<Player :playlist="['jRWR0Ob6mLI', '6s1n7Go6DK8', 'ICLDhAKKCtU']" :number-of-tracks-to-preload="2" :defaults="{autoplay: false, transitionDuration: 2}"></Player>-->
        <Player :playlist="playlist" :number-of-tracks-to-preload="2" :defaults="{autoplay: false, transitionDuration: 2}"></Player>
      </div>
    </div>
  </div>
</template>

<script>
import SingleTrackPlayer from "components/SingleTrackPlayer";
import Player from "components/Player";
import ytsr from "ytsr";

export default {
  name: "PlayerPlayground",
  components: {Player, SingleTrackPlayer},
  data() {
    return {
      body: '',
      playlist: [
        {
          type: 'video',
          title: 'First clip',
          id: 'jRWR0Ob6mLI',
          url: 'https://www.youtube.com/watch?v=KDtuZilDITs',
          bestThumbnail: {
            url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAcUkPHpEocFk1MLQfSTGZ_usWOmg',
            width: 720,
            height: 404
          },
          thumbnails: [
            {
              url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAcUkPHpEocFk1MLQfSTGZ_usWOmg',
              width: 720,
              height: 404
            },
            {
              url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEjCOgCEMoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDsQKS1SNV_Gt_VMwPrAfPmfQR63A',
              width: 360,
              height: 202
            }
          ],
          isUpcoming: false,
          upcoming: null,
          isLive: false,
          badges: [ 'New' ],
          author: {
            name: 'NoCopyrightSounds',
            channelID: 'UC_aEa8K-EOJ3D6gOs7HcyNg',
            url: 'https://www.youtube.com/user/NoCopyrightSounds',
            bestAvatar: {
              url: 'https://yt3.ggpht.com/a-/AOh14GhS0G5FwV8rMhVCUWSDp36vWEvnNs5Vl97Zww=s68-c-k-c0x00ffffff-no-rj-mo',
              width: 68,
              height: 68
            },
            avatars: [
              {
                url: 'https://yt3.ggpht.com/a-/AOh14GhS0G5FwV8rMhVCUWSDp36vWEvnNs5Vl97Zww=s68-c-k-c0x00ffffff-no-rj-mo',
                width: 68,
                height: 68
              }
            ],
            ownerBadges: [ 'Verified' ],
            verified: true
          },
          description: 'NCS: Music Without Limitations Our Spotify Playlist → http://spoti.fi/NCS Free Download / Stream: http://ncs.io/NeverStop [NCS] ...',
          views: 268586,
          duration: '2:36',
          uploadedAt: '1 day ago'
        },
        {
          type: 'video',
          title: 'Second clip',
          id: '6s1n7Go6DK8',
          url: 'https://www.youtube.com/watch?v=KDtuZilDITs',
          bestThumbnail: {
            url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAcUkPHpEocFk1MLQfSTGZ_usWOmg',
            width: 720,
            height: 404
          },
          thumbnails: [
            {
              url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAcUkPHpEocFk1MLQfSTGZ_usWOmg',
              width: 720,
              height: 404
            },
            {
              url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEjCOgCEMoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDsQKS1SNV_Gt_VMwPrAfPmfQR63A',
              width: 360,
              height: 202
            }
          ],
          isUpcoming: false,
          upcoming: null,
          isLive: false,
          badges: [ 'New' ],
          author: {
            name: 'NoCopyrightSounds',
            channelID: 'UC_aEa8K-EOJ3D6gOs7HcyNg',
            url: 'https://www.youtube.com/user/NoCopyrightSounds',
            bestAvatar: {
              url: 'https://yt3.ggpht.com/a-/AOh14GhS0G5FwV8rMhVCUWSDp36vWEvnNs5Vl97Zww=s68-c-k-c0x00ffffff-no-rj-mo',
              width: 68,
              height: 68
            },
            avatars: [
              {
                url: 'https://yt3.ggpht.com/a-/AOh14GhS0G5FwV8rMhVCUWSDp36vWEvnNs5Vl97Zww=s68-c-k-c0x00ffffff-no-rj-mo',
                width: 68,
                height: 68
              }
            ],
            ownerBadges: [ 'Verified' ],
            verified: true
          },
          description: 'NCS: Music Without Limitations Our Spotify Playlist → http://spoti.fi/NCS Free Download / Stream: http://ncs.io/NeverStop [NCS] ...',
          views: 268586,
          duration: '2:36',
          uploadedAt: '1 day ago'
        },
        {
          type: 'video',
          title: 'Third clip',
          id: 'ICLDhAKKCtU',
          url: 'https://www.youtube.com/watch?v=KDtuZilDITs',
          bestThumbnail: {
            url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAcUkPHpEocFk1MLQfSTGZ_usWOmg',
            width: 720,
            height: 404
          },
          thumbnails: [
            {
              url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAcUkPHpEocFk1MLQfSTGZ_usWOmg',
              width: 720,
              height: 404
            },
            {
              url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEjCOgCEMoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDsQKS1SNV_Gt_VMwPrAfPmfQR63A',
              width: 360,
              height: 202
            }
          ],
          isUpcoming: false,
          upcoming: null,
          isLive: false,
          badges: [ 'New' ],
          author: {
            name: 'NoCopyrightSounds',
            channelID: 'UC_aEa8K-EOJ3D6gOs7HcyNg',
            url: 'https://www.youtube.com/user/NoCopyrightSounds',
            bestAvatar: {
              url: 'https://yt3.ggpht.com/a-/AOh14GhS0G5FwV8rMhVCUWSDp36vWEvnNs5Vl97Zww=s68-c-k-c0x00ffffff-no-rj-mo',
              width: 68,
              height: 68
            },
            avatars: [
              {
                url: 'https://yt3.ggpht.com/a-/AOh14GhS0G5FwV8rMhVCUWSDp36vWEvnNs5Vl97Zww=s68-c-k-c0x00ffffff-no-rj-mo',
                width: 68,
                height: 68
              }
            ],
            ownerBadges: [ 'Verified' ],
            verified: true
          },
          description: 'NCS: Music Without Limitations Our Spotify Playlist → http://spoti.fi/NCS Free Download / Stream: http://ncs.io/NeverStop [NCS] ...',
          views: 268586,
          duration: '2:36',
          uploadedAt: '1 day ago'
        },
        {
          type: 'video',
          title: 'Todd Helder - Never Stop [NCS Release]',
          id: 'KDtuZilDITs',
          url: 'https://www.youtube.com/watch?v=KDtuZilDITs',
          bestThumbnail: {
            url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAcUkPHpEocFk1MLQfSTGZ_usWOmg',
            width: 720,
            height: 404
          },
          thumbnails: [
            {
              url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAcUkPHpEocFk1MLQfSTGZ_usWOmg',
              width: 720,
              height: 404
            },
            {
              url: 'https://i.ytimg.com/vi/KDtuZilDITs/hq720.jpg?sqp=-oaymwEjCOgCEMoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDsQKS1SNV_Gt_VMwPrAfPmfQR63A',
              width: 360,
              height: 202
            }
          ],
          isUpcoming: false,
          upcoming: null,
          isLive: false,
          badges: [ 'New' ],
          author: {
            name: 'NoCopyrightSounds',
            channelID: 'UC_aEa8K-EOJ3D6gOs7HcyNg',
            url: 'https://www.youtube.com/user/NoCopyrightSounds',
            bestAvatar: {
              url: 'https://yt3.ggpht.com/a-/AOh14GhS0G5FwV8rMhVCUWSDp36vWEvnNs5Vl97Zww=s68-c-k-c0x00ffffff-no-rj-mo',
              width: 68,
              height: 68
            },
            avatars: [
              {
                url: 'https://yt3.ggpht.com/a-/AOh14GhS0G5FwV8rMhVCUWSDp36vWEvnNs5Vl97Zww=s68-c-k-c0x00ffffff-no-rj-mo',
                width: 68,
                height: 68
              }
            ],
            ownerBadges: [ 'Verified' ],
            verified: true
          },
          description: 'NCS: Music Without Limitations Our Spotify Playlist → http://spoti.fi/NCS Free Download / Stream: http://ncs.io/NeverStop [NCS] ...',
          views: 268586,
          duration: '2:36',
          uploadedAt: '1 day ago'
        }
      ]
    }
  },
  methods: {
    playTrack1() {
      this.$refs.track1.play()
    },
    pauseTrack1() {
      this.$refs.track1.pause()
    },
    playTrack2() {
      this.$refs.track2.play()
    },
    pauseTrack2() {
      this.$refs.track2.pause()
    },
    async test() {
      this.body = await ytsr('Pable', {gl: 'FR', hl: 'fr'}) // Add a settings page if this bothers you
    },
    docopy() {
      this.$refs.cp.select();
      document.execCommand("copy");
    }
  }
}
</script>

<style scoped>

</style>
