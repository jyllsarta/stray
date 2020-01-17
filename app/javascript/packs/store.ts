import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex);

const store = new Vuex.Store({
  state: {
    ui: {
      // これに関してはUIシステム側で個別にストアを持つのが正解って気がするなあ
      position:{
        siroko: 100,
        kuroko: -40,
      },
      direction:{
        siroko: 1,
        kuroko: -1,
      },
    },
    user: {
      // これはもしかしたらレスポンスにあるものをまるまるあとから追加するほうがいいかもしれない
      // その場合ユーザモデルのロード完了までUI側でエラーが出続けるのがしんどいかもだけど検討できる
      hp: 100,
      hp_max: 1000,
      event_updated_at: 123123123,
    },
    masterdata: {

    },
    //データモデル的にはuserの中に入れるのが正解かもしれないけど、非同期周りで変数の更新しあいが発生すると悲惨なので独立させる
    events: [

    ],
  },
  mutations: {
    moveCharacter(state, payload) {
      state.ui.position[payload.characterName] += payload.delta * state.ui.direction[payload.characterName];
    },
    reflectCharacter(state, payload) {
      state.ui.direction[payload.characterName] *= -1;
    },
    updateUserModel(state, payload) {
      console.log(payload);
      state.user = payload;
    },
    updateMasterData(state, payload) {
      console.log(payload);
      state.masterdata = payload;
    },
    updateLatestEvents(state, payload) {
      console.log(payload);
      state.events = payload;
    },
  }
});
export default store;
