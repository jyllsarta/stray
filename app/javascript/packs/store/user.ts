import ax from "../axios_default_setting.ts";
import Constants from "../constants.ts";

export default {
  namespaced: true,
  state: {
    // レスポンスそのまま
    user_id: 999999999,
    items: {},
    dungeon_progresses: {},
    equips: {
      spica: [],
      tirol: [],
    },
    status: {
      current_dungeon_id: 1,
      current_dungeon_depth: 1,
      current_dungeon_rank: 1,
      coin: 0,
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
    isNearBossFloor(state, getters, rootState, rootGetters){
      const current_dungeon_id = state.status.current_dungeon_id;
      const max_depth = state.dungeon_progresses[current_dungeon_id]?.max_depth || 0;
      const unexplored = state.status.current_dungeon_depth+Constants.dungeon.bossLoseRewindFloor >= max_depth;
      const around_boss_floor = ((state.status.current_dungeon_depth+Constants.dungeon.bossLoseRewindFloor) % Constants.dungeon.bossFloorFrequency) <= Constants.dungeon.bossLoseRewindFloor;
      return unexplored && around_boss_floor;
    },
    currentStandardParameter: (state, getters) => {
      return getters.rankFactor(state.status.current_dungeon_rank);
    },
    aroundEnemyAtk: (state, getters) => {
      const actual_rank = getters.aroundEnemyRank;
      // str, def の基準値4つぶん*str+dex の合算になるので2倍で、基準パラメータの8倍が敵ATKになる
      return Math.floor(8 * getters.rankFactor(actual_rank));
    },
    aroundEnemyRank: (state, getters) => {
      return Math.floor(state.status.current_dungeon_rank * Constants.event.battle.enemyRankFactor + Constants.event.battle.enemyRankGeta);
    },
    rankFactor: (state, getters) => (rank) => {
      return Math.floor(Math.pow(rank, Constants.item.rankFactor));
    },
    rarityFactor: (state, getters) => (rarity) => {
      return Constants.item.rarityFactor[rarity];
    },
    maxItemRank: (state) => {
      return Object.values(state.items).reduce((max, item)=>(max < item.rank ? item.rank : max), 0);
    },
  },
  mutations: {
    syncEquipDraft(state, payload){
      ["spica", "tirol"].forEach(characterName=>{
        state.equips[characterName] = payload[characterName];
      });
    },
    incrementCurrentDungeonDepth(state){
      state.status.current_dungeon_depth++;
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
    updateItemRank(state, payload) {
      state.items[payload.item_id].rank = payload.rank;
    }
  },
  actions: {
    fetchUserModel ({ commit }) {
      return new Promise((resolve, reject) => {
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/status.json`;
        ax.get(path)
          .then((results) => {
            console.log(results);
            console.log("OK");
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
            console.log("OK");
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