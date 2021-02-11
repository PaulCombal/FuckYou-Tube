<template>
  <q-page class="q-pa-md column">

      <div class="col-2">
        <div class="text-h6 q-mb-lg">
          <q-btn icon="arrow_back" v-if="isChannelView" @click="toSearchView">Back to results</q-btn>
          <span v-else><q-icon class="on-left" name="search"/> Search results for "{{ $store.getters.getSearchText }}"</span>
        </div>
      </div>

      <div v-if="!loading">
        <q-tabs
          v-model="tab"
          dense
          class="text-grey"
          active-color="primary"
          indicator-color="primary"
          align="justify"
          narrow-indicator
        >
          <q-tab name="playlists" label="Playlists"/>
          <q-tab name="videos" label="Videos" :disable="isChannelView"/>
          <q-tab name="channels" label="Channels" :disable="isChannelView"/>
        </q-tabs>
      </div>

    <div class="col flex" v-if="!loading">
      <q-scroll-area style="flex: 1">
        <q-tab-panels v-model="tab" animated>
          <!-- PLAYLISTS -->
          <q-tab-panel name="playlists">
            <PlaylistItemCard @toggleFavorite="toggleFavorite" v-for="p in playlists" :key="p.playlistID" :favorites="pls" :playlist="p"></PlaylistItemCard>
<!--            <q-card flat bordered v-for="p in playlists" :key="p.playlistID" class="q-my-sm">
              <q-card-section horizontal class="justify-between">
                <q-card-section class="q-pt-xs">
                  <div class="text-overline">{{ p.length }} videos</div>
                  <div class="text-h5 q-mt-sm q-mb-xs">{{ p.title }}</div>
                  <div class="text-caption text-grey">
                    {{ p.owner.name }}
                  </div>
                </q-card-section>

                <q-space/>

                <q-card-section class="col-5 flex flex-center">
                  <q-img
                    class="rounded-borders"
                    :src="p.firstVideo.bestThumbnail.url"
                  />
                </q-card-section>

                <q-card-actions vertical class="justify-around">
                  <q-btn flat round color="red" :icon="isFavorite(p) ? 'favorite' : 'favorite_border'" @click="toggleFavorite(p)"/> &lt;!&ndash; favorite_border when needed &ndash;&gt;
                  <q-btn flat round color="accent" icon="playlist_play" @click="doQueuePlaylist(p)" />
                  <q-btn flat round color="primary" icon="shuffle" @click="doQueuePlaylist(p, true)" />
                </q-card-actions>

              </q-card-section>
            </q-card>-->
            <div v-if="!playlists.length && !loading" class="text-center">
              No playlist found
              <br/>
              <q-icon name="queue_music" class="text-grey q-pt-lg" style="font-size: 4em"></q-icon>
            </div>
          </q-tab-panel>

          <!-- VIDEOS -->
          <q-tab-panel name="videos">
            <q-card flat bordered v-for="v in videos" :key="v.id" class="q-my-sm" @click="doQueuePlaylist(v)">
              <q-card-section horizontal class="justify-between">
                <q-card-section class="q-pt-xs">
                  <div class="text-overline">{{ v.duration }}</div>
                  <div class="text-h5 q-mt-sm q-mb-xs">{{ v.title }}</div>
                  <div class="text-caption text-grey">
                    {{ v.author.name }}
                  </div>
                </q-card-section>

                <q-card-section class="col-5 flex flex-center">
                  <q-img
                    class="rounded-borders"
                    :src="v.bestThumbnail.url"
                  />
                </q-card-section>
              </q-card-section>
            </q-card>
            <div v-if="!videos.length && !loading" class="text-center">
              No videos found
              <br/>
              <q-icon name="audiotrack" class="text-grey q-pt-lg" style="font-size: 4em"></q-icon>
            </div>
          </q-tab-panel>

          <!-- CHANNELS -->
          <q-tab-panel name="channels">
            <q-card flat bordered v-for="c in channels" :key="c.channelID" class="q-my-sm" @click="toUserView(c)">
              <q-card-section horizontal class="justify-between">
                <q-card-section class="q-pt-xs">
                  <div class="text-overline">{{ c.subscribers }}</div>
                  <div class="text-h5 q-mt-sm q-mb-xs">{{ c.name }}</div>
                  <div class="text-caption text-grey">
                    {{ c.descriptionShort }}
                  </div>
                </q-card-section>

                <q-card-section class="col-5 flex flex-center">
                  <q-avatar>
                    <q-img
                      class="rounded-borders"
                      :src="c.bestAvatar.url"
                    />
                  </q-avatar>
                </q-card-section>
              </q-card-section>
            </q-card>

            <div v-if="!channels.length && !loading" class="text-center">
              No channels found
              <br/>
              <q-icon name="face" class="text-grey q-pt-lg" style="font-size: 4em"></q-icon>
            </div>
          </q-tab-panel>
        </q-tab-panels>
      </q-scroll-area>
    </div>


    <div v-else class="text-center">
      <div class="text-grey q-mb-lg">Loading..</div>
      <q-spinner-bars
        color="primary"
        size="2em"
      />
    </div>

  </q-page>
</template>

<script>
import ytsr from 'ytsr'
import ytpl from 'ytpl'
import shuffleArray from '../js/funcs.js'
import PlaylistItemCard from "components/PlaylistItemCard";

export default {
  name: "Search",
  components: {PlaylistItemCard},
  data() {
    return {
      loading: false,
      isChannelView: false,
      tab: 'playlists',
      res: [],
      cachedRes: null,
      pls: []
    }
  },
  methods: {
    async doSearch() {
      this.loading = true
      this.isChannelView = false
      try {
        this.res = await ytsr(this.$store.getters.getSearchText, {gl: 'FR', hl: 'fr'}) // Add a settings page if this bothers you
      } catch (e) {
        alert('kk'+e)
      }
      this.loading = false
    },
    async toUserView(item) {
      this.loading = true
      this.tab = 'playlists'
      this.isChannelView = true
      //this.res = await ytpl(item.channelID) // This would be used to get the uploaded videos, why not, but I dont want it
      this.cachedRes = this.res
      this.res = await ytpl.channelPlaylists(item.channelID)
      this.loading = false
    },
    toSearchView() {
      this.res = this.cachedRes
      this.isChannelView = false
    },
    isFavorite(item) {
      return this.pls.map(i => i.playlistID).includes(item.playlistID)
    },
    async toggleFavorite(item) {
      if (this.isFavorite(item)) {
        this.pls = this.pls.filter(i => i.playlistID !== item.playlistID)
      }
      else {
        this.pls.push(item)
      }
      localStorage.setItem('pls', JSON.stringify(this.pls))
    },
    async doQueuePlaylist(item, shuffle = false) {
      if (item.type === 'video') {
        this.$store.commit('setPlaylist', [item])
      } else if (item.type === 'playlist' || this.isChannelView) {
        this.loading = true
        /** @type ytpl.Result */
        const pl = await ytpl(item.playlistID, {pages: Infinity, limit: Infinity})
        console.log('first id', pl.items[0].id)
        if (shuffle) shuffleArray(pl.items)
        console.log('first id', pl.items[0].id)
        this.$store.commit('setPlaylist', pl.items)
      }

      await this.$router.push('/play')
    }
  },
  computed: {
    videos() {
      if (!this.res?.items) return []
      return this.res.items.filter(r => r.type === 'video')
    },
    playlists() {
      if (this.res.length && this.isChannelView)
        return this.res.map(p => ({
          length: p.estimatedItemCount,
          owner: {name: 'Selected user'},
          title: p.title,
          playlistID: p.id,
          firstVideo: {bestThumbnail: p.bestThumbnail}
        }))
      if (!this.res?.items) return []
      return this.res.items.filter(r => r.type === 'playlist')
    },
    channels() {
      if (!this.res?.items) return []
      return this.res.items.filter(r => r.type === 'channel')
    }
  },
  watch: {
    // oh oh terrible hack
    '$store.getters.getSearchText': function () {
      this.doSearch()
    }
  },
  mounted() {
    this.doSearch()
    const txt = localStorage.getItem('pls')
    if (!txt) return
    this.pls = JSON.parse(txt)
  }
}
</script>

<style scoped>

</style>
