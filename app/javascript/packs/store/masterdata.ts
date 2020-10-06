import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    dungeons: {},
    items: {},
    relics: {},
    skills: {},
    achievement_steps: {},
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
      state.skills = payload.masterdata.skills;
      state.achievement_steps = payload.masterdata.achievement_steps;
    },
  }
}