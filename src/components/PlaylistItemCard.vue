<template>
  <q-card flat bordered :key="playlist.playlistID" class="q-my-sm">
    <q-card-section horizontal class="justify-between">
      <q-card-section class="q-pt-xs">
        <div class="text-overline">{{ playlist.length }} videos</div>
        <div class="text-h5 q-mt-sm q-mb-xs">{{ playlist.title }}</div>
        <div class="text-caption text-grey">
          {{ playlist.owner.name }}
        </div>
      </q-card-section>

      <q-space/>

      <q-card-section class="col-5 flex flex-center">
        <q-img
          class="rounded-borders"
          :src="playlist.firstVideo.bestThumbnail.url"
        />
      </q-card-section>

      <q-card-actions vertical class="justify-around">
        <q-btn flat round color="red" :icon="isFavorite(playlist) ? 'favorite' : 'favorite_border'"
               @click="$emit('toggleFavorite', playlist)"/> <!-- favorite_border when needed -->
        <q-btn flat round color="accent" icon="playlist_play" @click="doQueuePlaylist(playlist)"/>
        <q-btn flat round color="primary" icon="shuffle" @click="doQueuePlaylist(playlist, true)"/>
      </q-card-actions>

    </q-card-section>
  </q-card>
</template>

<script>
import ytpl from "ytpl";
import shuffleArray from "src/js/funcs";

export default {
  name: "PlaylistItemCard",
  props: {
    playlist: {
      type: Object,
      required: true
    },
    favorites: {
      type: Array,
      required: true
    }
  },
  methods: {
    isFavorite(item) {
      return this.favorites.map(i => i.playlistID).includes(item.playlistID)
    },
    async doQueuePlaylist(item, shuffle = false) {
      /** @type ytpl.Result */
      const pl = await ytpl(item.playlistID, {pages: Infinity, limit: Infinity})
      if (shuffle) shuffleArray(pl.items)
      this.$store.commit('setPlaylist', pl.items)

      await this.$router.push('/play')
    }
  }
}
</script>

<style scoped>

</style>
