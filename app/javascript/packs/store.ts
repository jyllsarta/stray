import Vue from 'vue'
import Vuex from 'vuex'
import Constants from "./constants.ts";
Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    ui: {
      // これに関してはUIシステム側で個別にストアを持つのが正解って気がするなあ
      position:{
        siroko: 100,
        kuroko: -40,
      },
      direction:{
        siroko: 1,
        kuroko: -1,
      },
      // ウィンドウの開閉状況
      window: {
        account: false,
        equip: false,
      }
    },
    timer: {
      next_event: 99
    },
    // ユーザモデル更新で入る
    user: {
      // レスポンスそのまま
      user_id: 999999999,
      items: {},
    },
    masterdata: {
      // マスタデータロードで入る
    },
    //データモデル的にはuserの中に入れるのが正解かもしれないけど、非同期周りで変数の更新しあいが発生すると悲惨なので独立させる
    event: {
      next_event_at: 123123123,
      events: []
    },
  },
  mutations: {
    // ui系
    moveCharacter(state, payload) {
      state.ui.position[payload.characterName] += payload.delta * state.ui.direction[payload.characterName];
    },
    reflectCharacter(state, payload) {
      state.ui.direction[payload.characterName] *= -1;
    },
    updateWindowShowState(state, payload){
      state.ui.window[payload.windowName] = payload.state;
    },

    // ステート更新系
    updateUserModel(state, payload) {
      state.user = payload;
    },
    updateMasterData(state, payload) {
      state.masterdata = payload;
    },
    updateLatestEvents(state, payload) {
      state.event.next_event_at = payload.next_event_at;
      state.event.events = state.event.events.concat(payload.events);
    },
    incrementItemRank(state, payload) {
      state.user.items[payload.item_id].rank += payload.amount;
    },
    updateEventTimer(state, payload){
      state.timer.next_event = payload.time;
    }
  }
});
export default store;
