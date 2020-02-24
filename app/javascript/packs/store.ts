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
        equip: false,
      },
      guide: "-",
      equip_window: {
        main_character_id: 1, // 装備編集中のキャラID
        selecting_item_id: 0, // 現在マウスがあたってる装備ID
        current_page: 1,
        current_sort_id: 0,
        current_sort_order: 1, // 1:asc, -1:desc
        draft: {
          spica: [],
          tirol: [],
        },
        initial: {
          spica: [],
          tirol: [],
        },
      },
      event_illust: {
        showing: false,
        type: "item",
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

    masterdata: {
      dungeons: {},
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
    getCurrentSortLambda: (state, getters) => {
      const order = state.ui.equip_window.current_sort_order
      switch(state.ui.equip_window.current_sort_id){
        case 0:
          return (a, b) => { return (a.id - b.id) * order };
        case 1:
          return (a, b) => { return (getters.getItemEffectValue(a.id) - getters.getItemEffectValue(b.id)) * order };
        default:
          console.warn("undefined sort algorithm set");
        return null;
      }
    },
    getUserItemRank: (state) => (itemId) => {
      if(!state.user.items[itemId]){
        return 0;
      }
      return state.user.items[itemId].rank;
    },
    // 画面表示用(ランク0ならプラスを表示しない)
    getUserItemRankTextForDisplay: (state, getters) => (itemId) => {
      const rank = getters.getUserItemRank(itemId);
      // 0 はfalsy なことを使ったハック
      return rank ? `+${rank}`: "";
    },
    getItems: (state, getters) => {
      return Object.values(state.user.items).map(item=>getters.getUserItem(item.item_id));
    },
    getItemsWithPager: (state, getters) => {
      return Object.values(state.user.items)
          .map(item=>getters.getUserItem(item.item_id))
          .slice((state.ui.equip_window.current_page - 1) * Constants.itemsPerPage ,(state.ui.equip_window.current_page) * Constants.itemsPerPage)
          .filter(x=>x);
    },
    getItemsWithPagerSorted: (state, getters) => {
      return Object.values(state.user.items)
          .map(item=>getters.getUserItem(item.item_id))
          .sort(getters.getCurrentSortLambda)
          .slice((state.ui.equip_window.current_page - 1) * Constants.itemsPerPage ,(state.ui.equip_window.current_page) * Constants.itemsPerPage)
          .filter(x=>x);
    },
    getUserItem: (state) => (itemId) => {
      if(!state.user.items[itemId] || !state.masterdata.items[itemId]){
        return null;
      }
      let ui = Object.assign(state.user.items[itemId], state.masterdata.items[itemId]);
      ui.effectValueOf = function (paramName) {
        return Math.floor(this[paramName] + 0.1 * this.rank * this[paramName]);
      };
      return ui;
    },
    getItemEffectValue: (state, getters) => (itemId) => {
      const item = getters.getUserItem(itemId);
      if(!item){
        return 0;
      }
      return ['str', 'dex', 'def', 'agi'].reduce((p,x)=>(p + item.effectValueOf(x)), 0);
    },
    getItemRarityIcon: (state) => (itemId) => {
      const item = state.masterdata.items[itemId];
      if(!item){
        return "";
      }
      return [null, "", "*", "☆", "★", "◆"][item.rarity];
    },
    isAlreadyEquippedBySomeone: (state) => (itemId) => {
      return state.ui.equip_window.draft.spica.concat(state.ui.equip_window.draft.tirol).includes(itemId)
    },
    getCharacterParameter: (state, getters) => (characterId, paramName, isCurrent) => {
      const env = isCurrent ? 'draft' : 'initial';
      const characterName =  [null, "spica", "tirol"][characterId];
      const equipParameter = state.ui.equip_window[env][characterName].reduce((p,x)=>(p + getters.getUserItem(x).effectValueOf(paramName)), 0)
      const defaultParameter = Constants.character.defaultParameters[characterName][paramName];
      return equipParameter + defaultParameter;
    },
    getCharacterStrength: (state, getters) => (characterId, paramName, isCurrent) => {
      const sourceParamNames = paramName == 'atk' ? ['str', 'dex'] : ['def', 'agi'];
      const params = sourceParamNames.map(p=>getters.getCharacterParameter(characterId, p, isCurrent));
      return Math.floor((params[0] + params[1]) / 2) + Math.min(params[0], params[1]);
    },
    getCharacterStrengthDiff: (state, getters) => (characterId, paramName) => {
      return getters.getCharacterStrength(characterId, paramName, true) - getters.getCharacterStrength(characterId, paramName, false);
    },
    getCurrentDungeon: (state) => {
      //このスタブもnull安全演算子があれば回避できるんだけどなあ
      return state.masterdata.dungeons[state.user.status.current_dungeon_id] || {};
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
    changePage(state, payload){
      let page = state.ui.equip_window.current_page;
      page += payload;
      const maxPage = Math.ceil(Object.keys(state.user.items).length / Constants.itemsPerPage);
      if(page > maxPage){
        page = maxPage;
      }
      if(page < 1){
        page = 1;
      }
      state.ui.equip_window.current_page = page;
    },
    syncEquipDraft(state){
      ["spica", "tirol"].forEach(characterName=>{
        state.user.equips[characterName] = state.ui.equip_window.draft[characterName];
      });
    },
    removeEquip(state, payload){
      const characterName = [null, "spica", "tirol"][payload.characterId];
      state.ui.equip_window.draft[characterName] = state.ui.equip_window.draft[characterName].filter(i=>i!==payload.itemId)
    },
    attachEquip(state, payload){
      const characterName = [null, "spica", "tirol"][payload.characterId];
      if(state.ui.equip_window.draft[characterName].length >= Constants.maxEquipCount){
        return;
      }
      state.ui.equip_window.draft[characterName] = state.ui.equip_window.draft[characterName].concat(payload.itemId);
    },
    switchMainCharacter(state){
      state.ui.equip_window.main_character_id = state.ui.equip_window.main_character_id === 1 ? 2 : 1;
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
    reverseItemSortOrder(state){
      state.ui.equip_window.current_sort_order *= -1;
    },
    switchItemSortLambda(state, payload){
      state.ui.equip_window.current_sort_id = payload;
    },
    showEventIllust(state, payload){
      state.ui.event_illust.showing = true;
      state.ui.event_illust.type = payload;
    },
    removeEventIllust(state, payload){
      state.ui.event_illust.showing = false;
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
    updateEventTimer(state, payload){
      state.timer.next_event = payload.time;
    }
  }
});
export default store;
