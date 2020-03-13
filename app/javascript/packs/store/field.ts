import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    position:{
      spica: 100,
      tirol: -40,
    },
    direction:{
      spica: 1,
      tirol: -1,
    },
  },
  getters: {
  },
  mutations: {
    moveCharacter(state, payload) {
      state.position[payload.characterName] += payload.delta * state.direction[payload.characterName];
    },
    reflectCharacter(state, payload) {
      state.direction[payload.characterName] *= -1;
    },
  }
}