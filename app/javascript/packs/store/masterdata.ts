import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    dungeons: {},
    items: {},
    relics: {},
  },
  getters: {
    getCurrentDungeon: (state, getters, rootState, rootGetters) => {
      //このスタブもnull安全演算子があれば回避できるんだけどなあ
      return state.dungeons[rootState.user.status.current_dungeon_id] || {};
    }
  },
  mutations: {
    updateMasterData(state, payload) {
      state.dungeons = payload.masterdata.dungeons;
      state.items = payload.masterdata.items;
      state.relics = payload.masterdata.relics;
    },
  }
}