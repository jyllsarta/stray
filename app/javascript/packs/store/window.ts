import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    account: false,
    equip: false,
    equip_detail: false,
    switch_dungeon: false,
    relic: false,
    profile: false,
    battle: false,
    battle_prepare: false,
    quest: false,
    gacha: false,
    equip_skill: false,
    achievement: false,
    transition_frame: false,
    ending: false,
    loading_frame: true,
    session_expired_frame: false,
  },
  getters: {
    isOnFullScreen(state){
      return state.battle || state.ending || state.session_expired_frame;
    },
  },
  mutations: {
    updateWindowShowState(state, payload){
      state[payload.windowName] = payload.state;
    },
  }
}