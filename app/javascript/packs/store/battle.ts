import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    enemy_id: 0,
  },
  getters: {
  },
  mutations: {
    setEnemyId(state, payload){
      state.enemy_id = payload;
    }
  }
}