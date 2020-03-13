import { store } from '../store.ts'
import Constants from "../constants.ts";

export default {
  namespaced: true,
  state: {
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
  getters: {
    // TODO: 将来的にはUserItemモデルを返すようにしなければならない気がしている
    getCurrentEquipsByCharacterId: (state, getters, rootState, rootGetters) => (characterId) => {
      const characterName = [null, "spica", "tirol"][characterId];
      const equips = state.draft[characterName];
      if(!equips){ //TODO: こんなふうにガード書かなきゃいけないのちょいしんどいね
        return [];
      }
      return equips.map(c => rootState.masterdata.items[c])
    },
    getSubCharacterId: (state) => {
      // これでいいのか感はある
      return state.main_character_id === 1 ? 2 : 1;
    },
    getMainCharacterName: (state) => {
      return [null, "spica", "tirol"][state.main_character_id];
    },
    getSubCharacterName: (state, getters) => {
      return [null, "spica", "tirol"][getters.getSubCharacterId];
    },
    getMainCharacterJapaneseName: (state) => {
      return [null, "スピカ", "チロル"][state.main_character_id];
    },
    getSubCharacterJapaneseName: (state, getters) => {
      return [null, "スピカ", "チロル"][getters.getSubCharacterId];
    },
    getCurrentSortLambda: (state, getters) => {
      const order = state.current_sort_order
      switch(state.current_sort_id){
        case 0:
          return (a, b) => { return (a.id - b.id) * order };
        case 1:
          return (a, b) => { return (getters.getItemEffectValue(a.id) - getters.getItemEffectValue(b.id)) * order };
        default:
          console.warn("undefined sort algorithm set");
          return null;
      }
    },
    getUserItemRank: (state, getters, rootState, rootGetters) => (itemId) => {
      if(!rootState.user.items[itemId]){
        return 0;
      }
      return rootState.user.items[itemId].rank;
    },
    // 画面表示用(ランク0ならプラスを表示しない)
    getUserItemRankTextForDisplay: (state, getters) => (itemId) => {
      const rank = getters.getUserItemRank(itemId);
      // 0 はfalsy なことを使ったハック
      return rank ? `+${rank}`: "";
    },
    getItems: (state, getters, rootState, rootGetters) => {
      return Object.values(rootState.user.items).map(item=>getters.getUserItem(item.item_id));
    },
    getItemsWithPager: (state, getters, rootState, rootGetters) => {
      return Object.values(rootState.user.items)
        .map(item=>getters.getUserItem(item.item_id))
        .slice((state.current_page - 1) * Constants.itemsPerPage ,(state.current_page) * Constants.itemsPerPage)
        .filter(x=>x);
    },
    getItemsWithPagerSorted: (state, getters, rootState, rootGetters) => {
      return Object.values(rootState.user.items)
        .map(item=>getters.getUserItem(item.item_id))
        .sort(getters.getCurrentSortLambda)
        .slice((state.current_page - 1) * Constants.itemsPerPage ,(state.current_page) * Constants.itemsPerPage)
        .filter(x=>x);
    },
    getUserItem: (state, getters, rootState, rootGetters) => (itemId) => {
      if(!rootState.user.items[itemId] || !rootState.masterdata.items[itemId]){
        return null;
      }
      let ui = Object.assign(rootState.user.items[itemId], rootState.masterdata.items[itemId]);
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
    getItemRarityIcon: (state, getters, rootState, rootGetters) => (itemId) => {
      const item = rootState.masterdata.items[itemId];
      if(!item){
        return "";
      }
      return [null, "", "*", "☆", "★", "◆"][item.rarity];
    },
    isAlreadyEquippedBySomeone: (state) => (itemId) => {
      return state.draft.spica.concat(state.draft.tirol).includes(itemId)
    },
    getCharacterParameter: (state, getters) => (characterId, paramName, isCurrent) => {
      const env = isCurrent ? 'draft' : 'initial';
      const characterName =  [null, "spica", "tirol"][characterId];
      const equipParameter = state[env][characterName].reduce((p,x)=>(p + getters.getUserItem(x).effectValueOf(paramName)), 0)
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
  },
  mutations: {
    updateSelectingItemId(state, payload){
      state.selecting_item_id = payload;
    },
    removeEquip(state, payload){
      const characterName = [null, "spica", "tirol"][payload.characterId];
      state.draft[characterName] = state.draft[characterName].filter(i=>i!==payload.itemId)
    },
    attachEquip(state, payload){
      const characterName = [null, "spica", "tirol"][payload.characterId];
      if(state.draft[characterName].length >= Constants.maxEquipCount){
        return;
      }
      state.draft[characterName] = state.draft[characterName].concat(payload.itemId);
    },
    switchMainCharacter(state){
      state.main_character_id = state.main_character_id === 1 ? 2 : 1;
    },
    reverseItemSortOrder(state){
      state.current_sort_order *= -1;
    },
    switchItemSortLambda(state, payload){
      state.current_sort_id = payload;
    },
    changePage(state, payload){
      state.current_page = payload;
    }
  }
}