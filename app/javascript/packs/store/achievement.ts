import { store } from '../store.ts'
import ax from "../axios_default_setting.ts";

export default {
  namespaced: true,
  state: {
    loading: true,
    user_achievements: {},
    user_achievement_steps: {},
    user_completed_achievement_steps: [],
  },
  getters: {
  },
  mutations: {
    updateAchievements(state, payload) {
      state.user_achievements = payload.achievements;
      state.user_achievement_steps = payload.achievement_steps;
      state.loading = false;
    },
    setAchievementCache(state, payload) {
      state.user_completed_achievement_steps = payload.completed_achievements;
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
    fetchAchievementCache ({ commit }) {
      return new Promise((resolve, reject) => {
        const user_id = localStorage.user_id;
        const path = `/achievements/cache.json`;
        ax.get(path)
          .then((results) => {
            commit("setAchievementCache", results.data);
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