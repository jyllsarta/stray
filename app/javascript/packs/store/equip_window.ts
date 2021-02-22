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
  },
  getters: {
    getCurrentEquipsByCharacterId: (state, getters, rootState, rootGetters) => (characterId) => {
      const characterName = [null, "spica", "tirol"][characterId];
      const equips = state.draft[characterName];
      return equips?.map(c => getters.getUserItem(c));
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
            lambda: (a, b) => { return (b.id - a.id) },
            name: "ID順",
          };
        case 1:
          return {
            lambda: (a, b) => { return (getters.getItemEffectValue(b.id) - getters.getItemEffectValue(a.id)) },
            name: "総合順",
          };
        case 2:
          return {
            lambda: (a, b) => { return (getters.getUserItem(b.id).effectValueOf('str') - getters.getUserItem(a.id).effectValueOf('str')) },
            name: "STR順",
          };
        case 3:
          return {
            lambda: (a, b) => { return (getters.getUserItem(b.id).effectValueOf('dex') - getters.getUserItem(a.id).effectValueOf('dex')) },
            name: "DEX順",
          };
        case 4:
          return {
            lambda: (a, b) => { return (getters.getUserItem(b.id).effectValueOf('def') - getters.getUserItem(a.id).effectValueOf('def')) },
            name: "DEF順",
          };
        case 5:
          return {
            lambda: (a, b) => { return (getters.getUserItem(b.id).effectValueOf('agi') - getters.getUserItem(a.id).effectValueOf('agi')) },
            name: "AGI順",
          };
        case 6:
          return {
            lambda: (a, b) => {
              let item_b = (getters.getUserItem(b.id));
              let item_a = (getters.getUserItem(a.id));
              return (item_b.rank + item_b.base_rank) - (item_a.rank + item_a.base_rank)
            },
            name: "ランク順",
          };
        case 7:
          return {
            lambda: (a, b) => {
              const item_b = (getters.getUserItem(b.id));
              const item_a = (getters.getUserItem(a.id));
              return (item_b.tech() + item_b.power()) - (item_a.tech() + item_a.power());
            },
            name: "力+技順",
          };
        case 8:
          return {
            lambda: (a, b) => {
              const item_b = (getters.getUserItem(b.id));
              const item_a = (getters.getUserItem(a.id));
              return (item_b.power()) - (item_a.power());
            },
            name: "力順",
          };
        case 9:
          return {
            lambda: (a, b) => {
              const item_b = (getters.getUserItem(b.id));
              const item_a = (getters.getUserItem(a.id));
              return (item_b.tech()) - (item_a.tech());
            },
            name: "技順",
          };
        default:
          console.warn("undefined sort algorithm set");
          return null;
      }
    },
    getCurrentSortLambda: (state, getters) => {
      return getters.sortLambdas(state.current_sort_id).lambda;
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
    getUserItem: (state, getters, rootState, rootGetters) => (itemId, rankDelta=0) => {
      if(!rootState.user.items[itemId] || !rootState.masterdata.items[itemId]){
        return null;
      }
      let ui = Object.assign(rootState.user.items[itemId], rootState.masterdata.items[itemId]);
      ui.effectValueOf = function (paramName) {
        return Math.floor(this[paramName] / 100 * rootGetters['user/' +
        'rankFactor'](this.rank + this.base_rank + rankDelta) * rootGetters['user/rarityFactor'](this.rarity));
      };
      // NOTE: user/item.rb とがんばって共有すること
      // (sum * rarity_factor(item.rarity) * (item_rank / 250 + 1).clamp(1, 3) / 80 + 2).floor
      ui.tech = function () {
        return Math.floor((this.dex + this.agi) * rootGetters['user/rarityFactor'](this.rarity) * Math.min(Math.max(((this.rank + this.base_rank + rankDelta) / 250 + 1), 1), 3) / 80) + 2;
      };
      ui.power = function () {
        return Math.floor((this.str + this.def) * rootGetters['user/rarityFactor'](this.rarity) * Math.min(Math.max(((this.rank + this.base_rank + rankDelta) / 250 + 1), 1), 3) / 80) + 2;
      };

      ui.effectValue = ['str', 'dex', 'def', 'agi'].reduce((p,x)=>(p + ui.effectValueOf(x)), 0);
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
    getCharacterParameter: (state, getters, rootState) => (characterId, paramName, isCurrent) => {
      const env = isCurrent ? 'draft' : 'initial';
      const characterName =  [null, "spica", "tirol"][characterId];
      const equipParameter = state[env][characterName].reduce((p,x)=>(p + getters.getUserItem(x).effectValueOf(paramName)), 0);
      const characterRank = rootState.user.characters[characterName]?.rank || 1;
      const defaultParameter = Constants.character.defaultParameters[`rank${characterRank}`][paramName];
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
    averageItemRank: (state, getters) => () => {
      let sum = 0;
      for(let characterName of ['spica', 'tirol']){
         sum += state['draft'][characterName].reduce((p,x)=>(p + getters.getUserItem(x).rank + getters.getUserItem(x).base_rank), 0);
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