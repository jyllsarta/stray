import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    account: false,
    equip: false,
    switch_dungeon: false,
    transition_frame: false,
  },
  getters: {
  },
  mutations: {
    updateWindowShowState(state, payload){
      state[payload.windowName] = payload.state;
    },
  }
}