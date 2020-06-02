<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle', state: false})")
        .title
          | バトル！
      .body
        .start.clickable(@click="postEngage")
          | エンゲージ
        .start.clickable(@click="localBattle")
          | ローカルで戦闘してみる
        .start.clickable(@click="postShowdown")
          | ショウダウン
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import BattleFactory from "./packs/quest/battle_factory"


export default {
  data: function () {
    return {
      battle: null,
      input: null,
    };
  },
  store,
  mounted(){
  },
  methods: {
    localBattle(){
      if(!this.input){
        console.warn("まだエンゲージしてない");
        return;
      }
      this.battle = new BattleFactory(this.input).getBattle();
      this.battle.execute();
      console.log(`ローカルでの戦闘結果： isWin: ${this.battle.isWin()}`);
    },
    postEngage(){
      const path = `/enemies/-1/engage.json`;
      ax.post(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.input = results.data;
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    postShowdown(){
      const path = `/enemies/-1/showdown.json`;
      ax.post(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          console.log(`サーバでの戦闘結果： isWin: ${results.data.isWin}`);
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
  .body{
    .start{
      width: 100px;
      height: 30px;
      text-align: center;
    }
  }
</style>
