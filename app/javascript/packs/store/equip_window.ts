import Vue from "vue";
import Constants from "../constants.ts";

export default {
  namespaced: true,
  state: {
    main_character_id: 1, // 装備編集中のキャラID
    selecting_item_id: 0, // 現在マウスがあたってる装備ID
    current_page: 1,
    current_sort_id: 1,
    current_sort_order: -1, // 1:asc, -1:desc
    draft: {
      spica: [],
      tirol: [],
    },
    initial: {
      spica: [],
      tirol: [],
    },
    user_items: {},
    max_effect_value: 100,
    mock_item: {
      id: -1,
      effectValueOf: _=>0,
      tech: ()=>0,
      power: ()=>0,
    }
  },
  getters: {
    getCurrentEquipsByCharacterId: (state, getters, rootState, rootGetters) => (characterId) => {
      const characterName = [null, "spica", "tirol"][characterId];
      const equips = state.draft[characterName];
      return equips?.map(c => state.user_items[c] || state.mock_item);
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
    sortLambdas: (state, getters) => (id) => {
      switch(id){
        case 0:
          return {
            lambda: (a) => { return a.id },
            name: "ID順",
          };
        case 1:
          return {
            lambda: (a) => { return state.user_items[a.id].effectValue },
            name: "総合順",
          };
        case 2:
          return {
            lambda: (a) => { return state.user_items[a.id].effectValueOf('str') },
            name: "STR順",
          };
        case 3:
          return {
            lambda: (a) => { return state.user_items[a.id].effectValueOf('dex') },
            name: "DEX順",
          };
        case 4:
          return {
            lambda: (a) => { return state.user_items[a.id].effectValueOf('vit') },
            name: "VIT順",
          };
        case 5:
          return {
            lambda: (a) => { return state.user_items[a.id].effectValueOf('agi') },
            name: "AGI順",
          };
        case 6:
          return {
            lambda: (a) => {
              const item_a = state.user_items[a.id];
              return item_a.rank + item_a.base_rank;
            },
            name: "ランク順",
          };
        case 7:
          return {
            lambda: (a) => {
              const item_a = state.user_items[a.id];
              return item_a.tech() + item_a.power();
            },
            name: "力+技順",
          };
        case 8:
          return {
            lambda: (a) => {
              return state.user_items[a.id].power();
            },
            name: "力順",
          };
        case 9:
          return {
            lambda: (a) => {
              return state.user_items[a.id].tech();
            },
            name: "技順",
          };
        default:
          console.warn("undefined sort algorithm set");
          return null;
      }
    },
    getCurrentSortKey: (state, getters) => {
      return getters.sortLambdas(state.current_sort_id);
    },
    getCurrentSortLambda: (state, getters) => {
      const sort = getters.getCurrentSortKey;
      return (a, b) => {return sort.lambda(b) - sort.lambda(a)};
    },
    getStrongestSortLambda: (state, getters) => {
      const sort = getters.sortLambdas(1);
      return (a, b) => {return sort.lambda(b) - sort.lambda(a)};
    },
    getCurrentSortName: (state, getters) => {
      return getters.sortLambdas(state.current_sort_id).name;
    },
    getUserItemRank: (state, getters, rootState, rootGetters) => (itemId) => {
      return rootState.user?.items[itemId]?.rank || 0;
    },
    // 画面表示用(ランク0ならプラスを表示しない)
    getUserItemRankTextForDisplay: (state, getters) => (itemId) => {
      const rank = getters.getUserItemRank(itemId);
      // 0 はfalsy なことを使ったハック
      return rank ? `+${rank}`: "";
    },
    getItems: (state, getters, rootState, rootGetters) => {
      return Object.values(state.user_items);
    },
    getItemsWithPager: (state, getters, rootState, rootGetters) => {
      return Object.values(state.user_items)
        .slice((state.current_page - 1) * Constants.itemsPerPage ,(state.current_page) * Constants.itemsPerPage)
        .filter(x=>x);
    },
    getItemsWithPagerSorted: (state, getters, rootState, rootGetters) => {
      return Object.values(state.user_items)
        .sort(getters.getCurrentSortLambda)
        .slice((state.current_page - 1) * Constants.itemsPerPage ,(state.current_page) * Constants.itemsPerPage)
        .filter(x=>x);
    },
    getItemEffectValue: (state, getters) => (itemId) => {
      const item = state.user_items[itemId];
      if(!item){
        return 0;
      }
      return ['str', 'dex', 'vit', 'agi'].reduce((p,x)=>(p + item.effectValueOf(x)), 0);
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
    getCharacterParameter: (state, getters, rootState) => (characterId, paramName, isCurrent) => {
      const env = isCurrent ? 'draft' : 'initial';
      const characterName =  [null, "spica", "tirol"][characterId];
      const equipParameter = state[env][characterName].reduce((p,x)=>(p + state.user_items[x]?.effectValueOf(paramName) || 0), 0);
      const characterRank = rootState.user.characters[characterName]?.rank || 1;
      const defaultParameter = Constants.character.defaultParameters[`rank${characterRank}`][paramName];
      return equipParameter + defaultParameter;
    },
    getCharacterStrength: (state, getters) => (characterId, paramName, isCurrent) => {
      const sourceParamNames = paramName == 'atk' ? ['str', 'dex'] : ['vit', 'agi'];
      const params = sourceParamNames.map(p=>getters.getCharacterParameter(characterId, p, isCurrent));
      return Math.floor((params[0] + params[1]) / 2) + Math.min(params[0], params[1]);
    },
    getCharacterStrengthDiff: (state, getters) => (characterId, paramName) => {
      return getters.getCharacterStrength(characterId, paramName, true) - getters.getCharacterStrength(characterId, paramName, false);
    },
    getTotalStrength: (state, getters) => (paramName, isCurrent) => {
      const sourceParamNames = paramName == 'atk' ? ['str', 'dex'] : ['vit', 'agi'];
      const spicaParams = sourceParamNames.map(p=>getters.getCharacterParameter(1, p, isCurrent));
      const spicaTotal = Math.floor((spicaParams[0] + spicaParams[1]) / 2) + Math.min(spicaParams[0], spicaParams[1]);
      const tirolParams = sourceParamNames.map(p=>getters.getCharacterParameter(2, p, isCurrent));
      const tirolTotal = Math.floor((tirolParams[0] + tirolParams[1]) / 2) + Math.min(tirolParams[0], tirolParams[1]);
      return spicaTotal + tirolTotal;
    },
    getTotalStrengthDiff: (state, getters) => (paramName) => {
      return getters.getTotalStrength(paramName, true) - getters.getTotalStrength(paramName, false);
    },
    averageItemRank: (state, getters) => () => {
      let sum = 0;
      for(let characterName of ['spica', 'tirol']){
         sum += state['draft'][characterName].reduce((p,x)=>(p + state.user_items[x].rank + state.user_items[x].base_rank), 0);
      }
      return Math.floor(sum / (Constants.maxEquipCount * 2));
    },
  },
  mutations: {
    initializeEquipWindow(state, payload){
      ["spica", "tirol"].forEach(characterName=>{
        state.draft[characterName] = payload[characterName];
        state.initial[characterName] = payload[characterName];
      });
    },
    constructUserItems(state, payload){
      const items = payload.items;
      const user_items = payload.user_items;
      for(let user_item of Object.values(user_items)){
        let ui = Object.assign({}, user_item, items[user_item.item_id]);
        Object.assign(ui, items[user_item.item_id]);
        ui.rankFactor = function(rank) {
          return Math.floor(Math.pow(Constants.item.rankFactor, rank) * 100) - 100;
        },
        ui.rarityFactor = function(rarity) {
          return Constants.item.rarityFactor[rarity];
        },
        ui.effectValueOf = function (paramName, rankDelta=0) {
          return Math.floor(this[paramName] / 100 * this.rankFactor(this.rank + this.base_rank + rankDelta) * this.rarityFactor(this.rarity));
        };
        ui.tech = function (rankDelta=0) {
          return Math.floor((this.dex + this.agi) * this.rarityFactor(this.rarity) * Math.min(Math.max(((this.rank + this.base_rank + rankDelta) / 250 + 1), 1), 3) / 80) + 2;
        };
        ui.power = function (rankDelta=0) {
          return Math.floor((this.str + this.vit) * this.rarityFactor(this.rarity) * Math.min(Math.max(((this.rank + this.base_rank + rankDelta) / 250 + 1), 1), 3) / 80) + 2;
        };  
        ui.effectValue = ['str', 'dex', 'vit', 'agi'].reduce((p,x)=>(p + ui.effectValueOf(x)), 0);
        Vue.set(state.user_items, ui.item_id, ui);
      }
      state.max_effect_value = Object.values(state.user_items).map(ui=>ui.effectValue).reduce((p,x)=>(Math.max(p, x)), 0);
    },
    updateSelectingItemId(state, payload){
      state.selecting_item_id = payload;
    },
    removeEquip(state, payload){
      const characterName = [null, "spica", "tirol"][payload.characterId];
      state.draft[characterName] = state.draft[characterName].filter(i=>i!==payload.itemId);
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
    },
    syncInitialToDraft(state){
      Object.assign(state.initial, state.draft);
    },
  }
}