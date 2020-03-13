import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    message: "-",
  },
  getters: {
  },
  mutations: {
    //こいつは簡便化のためにpayloadを直接代入
    updateGuide(state, payload){
      state.message = payload;
    },
  }
}