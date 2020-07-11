import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    skills: [],
  },
  getters: {
  },
  mutations: {
    setPlayerSkills(state, payload){
      state.skills = payload;
    }
  }
}