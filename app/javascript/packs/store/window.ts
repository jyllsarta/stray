import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    account: false,
    equip: false,
    equip_detail: false,
    switch_dungeon: false,
    relic: false,
    battle: false,
    battle_prepare: false,
    quest: false,
    equip_skill: false,
    achievement: true,
    transition_frame: false,
    loading_frame: true,
    session_expired_frame: false,
  },
  getters: {
  },
  mutations: {
    updateWindowShowState(state, payload){
      state[payload.windowName] = payload.state;
    },
  }
}