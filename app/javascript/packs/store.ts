import Vue from 'vue'
import Vuex from 'vuex'
import Constants from "./constants.ts";
import field from "./store/field.ts"
import window from "./store/window.ts"
import guide from "./store/guide.ts"
import event_illust from "./store/event_illust.ts"
import timer from "./store/timer.ts"
import equip_window from "./store/equip_window.ts";
import masterdata from "./store/masterdata.ts"
import event from "./store/event.ts"
import user from "./store/user.ts"
import battle from "./store/battle.ts"
import skill from "./store/skill.ts"
Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
  },
  getters: {
  },
  mutations: {
  },
  modules: {
    field: field,
    window: window,
    guide: guide,
    event_illust: event_illust,
    timer: timer,
    equip_window: equip_window,
    masterdata: masterdata,
    event: event,
    user: user,
    battle: battle,
    skill: skill,
  }
});
export default store;
