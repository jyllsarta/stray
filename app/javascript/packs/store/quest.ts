import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    quest_id: 1,
  },
  getters: {
  },
  mutations: {
    setQuest(state, payload){
      state.quest_id = payload;
    }
  }
}