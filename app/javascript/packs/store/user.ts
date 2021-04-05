import ax from "../axios_default_setting.ts";
import Constants from "../constants.ts";

export default {
  namespaced: true,
  state: {
    // レスポンスそのまま
    user_id: 999999999,
    items: {},
    relics: {},
    dungeon_progresses: {},
    quest_battle_parameters: {},
    equips: {
      spica: [],
      tirol: [],
    },
    status: {
      current_dungeon_id: 1,
      current_dungeon_depth: 1,
      current_dungeon_rank: 1,
      coin: 0,
      star: 0,
      velocity: 100,
      max_item_rank_for_rankup: 100,
      won_last_boss: false,
      returns_on_death: false,
      skill_slot_count: 1,
    },
    characters: {
      spica: {},
      tirol: {},
    }
  },
  getters: {
    isAliveCharacter: (state) => (characterName) => {
      const character = state.characters[characterName];
      return character.hp > 0;
    },
    getCharacterHpPercent: (state) => (characterName) => {
      const character = state.characters[characterName];
      return character.hp / character.hp_max * 100;
    },
    isOverFloor(state, getters, rootState, rootGetters){
      const current_dungeon_id = state.status.current_dungeon_id;
      return state.status.current_dungeon_depth >= rootState.masterdata?.dungeons[current_dungeon_id]?.depth;
    },
    currentStandardParameter: (state, getters) => {
      return getters.rankFactor(state.status.current_dungeon_rank);
    },
    aroundEnemyAtk: (state, getters) => {
      const actual_rank = getters.aroundEnemyRank;
      // str, vit の基準値4つぶん*str+vit の合算になるので2倍で、基準パラメータの8倍が敵ATKになる
      return Math.floor(8 * getters.rankFactor(actual_rank));
    },
    aroundEnemyRank: (state, getters) => {
      return Math.floor(state.status.current_dungeon_rank);
    },
    // 処理負荷軽減のためにEquipWindow.tsにコピペしてある
    rankFactor: (state, getters) => (rank) => {
      return Math.floor(Math.pow(Constants.item.rankFactor, rank) * 100) - 100;
    },
    // 処理負荷軽減のためにEquipWindow.tsにコピペしてある
    rarityFactor: (state, getters) => (rarity) => {
      return Constants.item.rarityFactor[rarity];
    },
    maxItemRank: (state) => {
      return Object.values(state.items).reduce((max, item)=>(max < item.rank ? item.rank : max), 0);
    },
    hasEmptySlot: (state) => {
      return state.equips.spica.length + state.equips.tirol.length < Constants.maxEquipCount * 2;
    },
    // サーバでも定義共有してるので注意
    currentVelocityRank: (state) => {
      const v = state.status.velocity;
      if(v < 150){
        return 0;
      }
      if(v < 200){
        return 1;
      }
      if(v < 300){
        return 2;
      }
      return 3;
    }
  },
  mutations: {
    syncEquipDraft(state, payload){
      ["spica", "tirol"].forEach(characterName=>{
        state.equips[characterName] = payload[characterName];
      });
    },
    updateCurrentDungeonProgress(state, payload){
      if(!state.dungeon_progresses[state.status.current_dungeon_id]){
        console.log("マスタ読み込み前なので処理を中断します");
        return;
      }
      state.dungeon_progresses[state.status.current_dungeon_id].max_depth = payload;
    },
    applyBattleDamage(state, payload){
      state.characters.spica.hp -= payload[0];
      state.characters.tirol.hp -= payload[1];
    },
    resurrect(state){
      state.characters.spica.hp = state.characters.spica.hp_max;
      state.characters.tirol.hp = state.characters.tirol.hp_max;
    },
    // ステート更新系
    updateUserModel(state, payload) {
      Object.assign(state, payload);
    },
    // ステート更新系
    updateUserModelEventPartial(state, payload) {
      state.characters = payload.characters;
      state.status.coin = payload.coin;
      state.status.star = payload.star;
      state.status.velocity = payload.velocity;
      state.status.current_dungeon_depth = payload.current_dungeon_depth;
    },
    updateItemRank(state, payload) {
      state.items[payload.item_id].rank = payload.rank;
    },
    updateUserCoin(state, payload) {
      state.status.coin = payload;
    },
    updateUserReturnOnDeathStatus(state, payload){
      state.status.returns_on_death = payload;
    },
  },
  actions: {
    fetchUserModel ({ commit }) {
      return new Promise((resolve, reject) => {
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/status.json`;
        ax.get(path)
          .then((results) => {
            commit("updateUserModel", results.data.payload);
            resolve();
          })
          .catch((error) => {
            console.warn(error.response);
            console.warn("NG");
          });
      })
    },
    gotoDungeon ({ commit }, payload) {
      return new Promise((resolve, reject) => {
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/switch_dungeon.json`;
        ax.post(path, payload)
          .then((results) => {
            console.log(results);
            resolve();
          })
          .catch((error) => {
            console.warn(error.response);
            console.warn("NG");
          });
      })
    },
    switchReturnsOnDeath ({ commit }, payload) {
      return new Promise((resolve, reject) => {
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/switch_returns_on_death.json`;
        ax.post(path, payload)
          .then((results) => {
            console.log(results);
            commit("updateUserReturnOnDeathStatus", results.data.returns_on_death);
            resolve();
          })
          .catch((error) => {
            console.warn(error.response);
            console.warn("NG");
          });
      })
    },
    rankUpItem ({ commit }, payload) {
      return new Promise((resolve, reject) => {
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/user_items/${payload.item_id}/rank_up.json`;
        ax.post(path, {count: payload.count})
          .then((results) => {
            console.log(results);
            commit("updateUserCoin", results.data.after_coin);
            commit("updateItemRank", {item_id: results.data.item_id, rank: results.data.after_rank});
            resolve();
          })
          .catch((error) => {
            console.warn(error);
            console.warn(error.response);
            console.warn("NG");
          });
      })
    },
    obtainRelic ({ commit }, payload) {
      return new Promise((resolve, reject) => {
        const user_id = localStorage.user_id;
        const path = `/relics`;
        ax.post(path, {relic_id: payload})
          .then((results) => {
            console.log(results);
            resolve();
          })
          .catch((error) => {
            console.warn(error.response);
            console.warn("NG");
          });
      })
    },

  }
}