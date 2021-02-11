<template>
  <q-page class="q-pa-md">
<!--    <div class="row">
      <div class="col">
        button back to main
      </div>
    </div>-->
    <div class="row">
      <div class="col">
        <Player
          :number-of-tracks-to-preload="2"
          :playlist="$store.getters.getPlaylist"
        ></Player>
      </div>
    </div>
  </q-page>
</template>

<script>
import Player from "components/Player";
export default {
  name: "PlayerPage",
  components: {Player}
}
</script>

<style scoped>

</style>
