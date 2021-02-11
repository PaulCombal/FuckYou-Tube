import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

/*
 * If not building with SSR mode, you can
 * directly export the Store instantiation;
 *
 * The function below can be async too; either use
 * async/await or return a Promise which resolves
 * with the Store instance.
 */

export default function (/* { ssrContext } */) {
  return new Vuex.Store({
    state: {
      searchText: '',
      playlist: []
    },
    mutations: {
      setSearch(state, text) {
        state.searchText = text
      },
      setPlaylist(state, playlist) {
        state.playlist = playlist
      },
      clearPlaylist(state) {
        state.playlist = []
      }
    },
    getters: {
      getSearchText(state) {
        return state.searchText
      },
      getPlaylist(state) {
        return state.playlist
      }
    },

    // enable strict mode (adds overhead!)
    // for dev mode only
    strict: process.env.DEBUGGING
  })
}
