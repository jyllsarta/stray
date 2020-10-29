import { store } from '../store.ts'
import ax from "../axios_default_setting.ts";

export default {
  namespaced: true,
  state: {
    loading: true,
    achievements: {},
    achievement_steps: {},
  },
  getters: {
  },
  mutations: {
    updateAchievements(state, payload) {
      Object.assign(state, payload);
      state.loading = false;
    },
  },
  actions: {
    fetchAchievements ({ commit }) {
      return new Promise((resolve, reject) => {
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/achievements.json`;
        ax.get(path)
          .then((results) => {
            commit("updateAchievements", results.data);
            resolve();
          })
          .catch((error) => {
            console.warn(error.response);
            console.warn("NG");
          });
      })
    },
    sendClientAchievement ({ commit }, event_name) {
      return new Promise((resolve, reject) => {
        const path = `/achievements/complete.json`;
        ax.post(path, {event_name: event_name})
          .then((results) => {
            resolve();
          })
          .catch((error) => {
            console.warn(error.response);
            console.warn("NG");
          });
      })
    },
  }
}