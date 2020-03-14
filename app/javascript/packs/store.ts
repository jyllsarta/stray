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
Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    // ユーザモデル更新で入る
    user: {
      // レスポンスそのまま
      user_id: 999999999,
      items: {},
      equips: {
        spica: [],
        tirol: [],
      },
      status: {
        current_dungeon_id: 1,
        current_dungeon_depth: 1,
      },
      characters: {
        spica: {},
        tirol: {},
      }
    },
  },
  getters: {
  },
  mutations: {
    syncEquipDraft(state, payload){
      ["spica", "tirol"].forEach(characterName=>{
        state.user.equips[characterName] = payload[characterName];
      });
    },
    incrementCurrentDungeonDepth(state){
      state.user.status.current_dungeon_depth++;
    },
    applyBattleDamage(state, payload){
      state.user.characters.spica.hp -= payload[0];
      state.user.characters.tirol.hp -= payload[1];
    },
    resurrect(state){
      state.user.characters.spica.hp = state.user.characters.spica.hp_max;
      state.user.characters.tirol.hp = state.user.characters.tirol.hp_max;
    },
    // ステート更新系
    updateUserModel(state, payload) {
      state.user = payload;
    },
    incrementItemRank(state, payload) {
      state.user.items[payload.item_id].rank += payload.amount;
    },
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
  }
});
export default store;
