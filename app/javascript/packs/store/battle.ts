import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    enemy_id: 0,
    fragments: {
      turn_start: false,
      player_skill: false,
      enemy_skill: false,
    }
  },
  getters: {
  },
  mutations: {
    setEnemyId(state, payload){
      state.enemy_id = payload;
    },
    showFragment(state, fragmentName){
      state.fragments[fragmentName] = true;
    },
    hideFragment(state, fragmentName){
      state.fragments[fragmentName] = false;
    },
  }
}