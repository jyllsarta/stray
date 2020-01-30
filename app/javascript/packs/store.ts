import Vue from 'vue'
import Vuex from 'vuex'
import Constants from "./constants.ts";
Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    // グローバルな画面状態これに関してはUIシステム側で個別にストアを持つのが正解って気がするなあ
    ui: {
      position:{
        spica: 100,
        tirol: -40,
      },
      direction:{
        spica: 1,
        tirol: -1,
      },
      // ウィンドウの開閉状況
      window: {
        account: false,
        equip: true,
      },
      guide: "ここにガイドが出るよ",
      equip_window: {
        main_character_id: 1, //装備編集中のキャラID
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
      equips: {
        1: [],
        2: [],
      }
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
  getters: {
    // 将来的にはUserItemモデルを返すようにしなければならない気がしている
    getEquipsByCharacterId: (state) => (characterId) => {
      const characterName = [null, "spica", "tirol"][characterId];
      const equips = state.user.equips[characterName];
      if(!equips){ //こんなふうにガード書かなきゃいけないのちょいしんどいね
        return [];
      }
      return equips.map(c => state.masterdata.items[c])
    },
    getSubCharacterId: (state) => {
      // これでいいのか感はある
      return state.ui.equip_window.main_character_id === 1 ? 2 : 1;
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
    //こいつは簡便化のためにpayloadを直接代入
    updateGuide(state, payload){
      state.ui.guide = payload;
    },

    // ステート更新系
    updateUserModel(state, payload) {
      state.user = payload;
    },
    updateMasterData(state, payload) {
      state.masterdata = payload.masterdata;
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
