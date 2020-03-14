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

    //データモデル的にはuserの中に入れるのが正解かもしれないけど、非同期周りで変数の更新しあいが発生すると悲惨なので独立させる
    event: {
      next_event_at: 123123123,
      events: []
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
    updateLatestEvents(state, payload) {
      state.event.next_event_at = payload.next_event_at;
      state.event.events = state.event.events.concat(payload.events);
    },
    addEventLog(state, payload){
      const manualEvent = {
        resolved: true,
        detail: {},
        logs: [
          {
            // 手動追加されるログは同時刻に発生することがあり得るので、ユニーク性を担保するためにサロゲートキーを発行する
            pseudo_id: Math.floor(Math.random() * 1000000000),
            at: Math.floor(new Date()/1000),
            message: payload.message,
          }
        ],
        type: payload.type,
      };
      state.event.events.push(manualEvent);
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
  }
});
export default store;
