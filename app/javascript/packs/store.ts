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
        main_character_id: 1, // 装備編集中のキャラID
        selecting_item_id: 1, // 現在マウスがあたってる装備ID
        draft: {
          spica: [],
          tirol: [],
        },
        initial: {
          spica: [],
          tirol: [],
        },
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
    // TODO: 将来的にはUserItemモデルを返すようにしなければならない気がしている
    getCurrentEquipsByCharacterId: (state) => (characterId) => {
      const characterName = [null, "spica", "tirol"][characterId];
      const equips = state.ui.equip_window.draft[characterName];
      if(!equips){ //TODO: こんなふうにガード書かなきゃいけないのちょいしんどいね
        return [];
      }
      return equips.map(c => state.masterdata.items[c])
    },
    getSubCharacterId: (state) => {
      // これでいいのか感はある
      return state.ui.equip_window.main_character_id === 1 ? 2 : 1;
    },
    getMainCharacterName: (state) => {
      return [null, "spica", "tirol"][state.ui.equip_window.main_character_id];
    },
    getSubCharacterName: (state, getters) => {
      return [null, "spica", "tirol"][getters.getSubCharacterId];
    },
    getMainCharacterJapaneseName: (state) => {
      return [null, "スピカ", "チロル"][state.ui.equip_window.main_character_id];
    },
    getSubCharacterJapaneseName: (state, getters) => {
      return [null, "スピカ", "チロル"][getters.getSubCharacterId];
    },
    getUserItemRank: (state) => (itemId) => {
      if(!state.user.items[itemId]){
        return 0;
      }
      return state.user.items[itemId].rank;
    },
    // TODO: 今後page制御されることになるんだと思う
    getItems: (state, getters) => {
      return Object.values(state.user.items).map(item=>getters.getUserItem(item.item_id));
    },
    getUserItem: (state) => (itemId) => {
      if(!state.user.items[itemId] || !state.masterdata.items[itemId]){
        return {
          // TODO: エラーを吐かせないためにこんなことしなきゃいけないの純粋にしんどい
          // マウント順の制御とかできるのでしょうか...アルファ開発が終わったら手を付ける
          effectValueOf: (i)=>0,
        };
      }
      let ui = Object.assign(state.user.items[itemId], state.masterdata.items[itemId]);
      ui.effectValueOf = function (paramName) {
        return Math.floor(this[paramName] + 0.1 * this.rank + this[paramName]);
      };
      return ui;
    },
    getItemEffectValue: (state, getters) => (itemId) => {
      const item = getters.getUserItem(itemId);
      return ['str', 'dex', 'def', 'agi'].reduce((p,x)=>(p + item.effectValueOf(x)), 0);
    },
    getItemRarityIcon: (state, getter) => (itemId) => {
      const item = state.masterdata.items[itemId];
      return [null, "", "*", "☆", "★", "◆"][item.rarity];
    },
    isAlreadyEquippedBySomeone: (state) => (itemId) => {
      return state.ui.equip_window.draft.spica.concat(state.ui.equip_window.draft.tirol).includes(itemId)
    },
    getCurrentCharacterParameter: (state, getters) => (characterId, paramName) => {
      const characterName =  [null, "spica", "tirol"][characterId];
      return state.ui.equip_window.draft[characterName].reduce((p,x)=>(p + getters.getUserItem(x).effectValueOf(paramName)), 0);
    }
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
    updateSelectingItemId(state, payload){
      state.ui.equip_window.selecting_item_id = payload;
    },
    initializeEquipWindow(state){
      ["spica", "tirol"].forEach(characterName=>{
        state.ui.equip_window.draft[characterName] = state.user.equips[characterName];
        state.ui.equip_window.initial[characterName] = state.user.equips[characterName];
      });
    },
    removeEquip(state, payload){
      const characterName = [null, "spica", "tirol"][payload.characterId];
      state.ui.equip_window.draft[characterName] = state.ui.equip_window.draft[characterName].filter(i=>i!==payload.itemId)
    },
    attachEquip(state, payload){
      const characterName = [null, "spica", "tirol"][payload.characterId];
      state.ui.equip_window.draft[characterName].push(payload.itemId);
    },
    switchMainCharacter(state){
      state.ui.equip_window.main_character_id = state.ui.equip_window.main_character_id === 1 ? 2 : 1;
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
