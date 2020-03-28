import ax from "../axios_default_setting.ts";
import Constants from "../constants.ts";

export default {
  namespaced: true,
  state: {
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
      current_dungeon_rank: 1,
    },
    characters: {
      spica: {},
      tirol: {},
    }
  },
  getters: {
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
      const actual_rank = state.status.current_dungeon_rank * Constants.event.battle.enemyRankFactor + Constants.event.battle.enemyRankGeta;
      // str, def の基準値の2倍でエネミーのATKが生成されるので 2 倍
      return Math.floor(2 * getters.rankFactor(actual_rank));
    },
    rankFactor: (state, getters) => (rank) => {
      return Math.pow(rank, Constants.item.rankFactor);
    },
    rarityFactor: (state, getters) => (rarity) => {
      return Constants.item.rarityFactor[rarity];
    },
  }
  ,
  mutations: {
    syncEquipDraft(state, payload){
      ["spica", "tirol"].forEach(characterName=>{
        state.equips[characterName] = payload[characterName];
      });
    },
    incrementCurrentDungeonDepth(state){
      state.status.current_dungeon_depth++;
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
    incrementItemRank(state, payload) {
      state.items[payload.item_id].rank += payload.amount;
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
  }
}