import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    showing: false,
    type: "item",
  },
  getters: {
  },
  mutations: {
    showEventIllust(state, payload){
      state.showing = true;
      state.type = payload;
    },
    removeEventIllust(state, payload){
      state.showing = false;
    },
  }
}