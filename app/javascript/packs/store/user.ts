import { store } from '../store.ts'

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
    },
    characters: {
      spica: {},
      tirol: {},
    }
  },
  getters: {
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
    },

  }
}