import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    next_event: 99
  },
  getters: {
  },
  mutations: {
    updateEventTimer(state, payload){
      state.next_event = payload.time;
    }
  }
}