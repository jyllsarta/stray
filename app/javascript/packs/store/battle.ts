import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    enemy_id: 0,
    fragments: {
      turn_start: false,
      player_skill: false,
      enemy_skill: false,
      battle_outcome: false,
      player_damage: false,
      enemy_damage: false,
    },
    damageDiffs: {
      player: 0,
      enemy: 0,
    },
    currentBattleSkillCutinDetail: {
      name: "インビンシブル",
      description: "とにかく無敵になる。",
    }
  },
  getters: {
  },
  mutations: {
    setEnemyId(state, payload){
      state.enemy_id = payload;
    },
    setDamageDiff(state, payload){
      state.damageDiffs[payload.target] = payload.value;
    },
    setSkillCutinDetail(state, payload){
      state.currentBattleSkillCutinDetail = payload;
    },
    showFragment(state, fragmentName){
      state.fragments[fragmentName] = true;
    },
    hideFragment(state, fragmentName){
      state.fragments[fragmentName] = false;
    },
  }
}