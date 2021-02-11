<template>
  <q-page class="q-pa-md">
    <div class="row">
      <div class="col">
        <div class="text-h6">Saved playlists</div>
        <q-btn @click="$router.push('/test')">TEST</q-btn>
        <q-btn @click="alert('ddd')">ALert</q-btn>
      </div>
    </div>

    <SavedPlaylistBrowser></SavedPlaylistBrowser>
  </q-page>
</template>

<script>
import SavedPlaylistBrowser from "components/SavedPlaylistBrowser";

export default {
  name: 'PageIndex',
  components: {SavedPlaylistBrowser},
  methods: {
    alert(a) {
      alert(a)
    }
  }
}
</script>
