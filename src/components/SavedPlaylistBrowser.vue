<template>
  <div>
    <div class="row" v-for="p in pls">
      <div class="col">
        <PlaylistItemCard :favorites="pls" :playlist="p" @toggleFavorite="toggleFavorite" :key="p.playlistID"></PlaylistItemCard>
      </div>
    </div>

    <div class="row" v-if="!pls.length">
      <div class="col text-center">
        <span class="text-grey">No favorite playlist</span>
        <br/>
        <q-icon name="favorite_border" class="text-grey" size="2em"></q-icon>
      </div>
    </div>
  </div>
</template>

<script>
import PlaylistItemCard from "components/PlaylistItemCard";
export default {
  name: "SavedPlaylistBrowser",
  components: {PlaylistItemCard},
  data() {
    return {
      pls: []
    }
  },
  methods: {
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
  },
  mounted() {
    const txt = localStorage.getItem('pls')
    if (!txt) return
    this.pls = JSON.parse(txt)
  }
}
</script>

<style scoped>

</style>
