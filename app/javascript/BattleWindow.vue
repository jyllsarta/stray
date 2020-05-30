<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle', state: false})")
        .title
          | バトル！
      .body
        .start.clickable(@click="startBattle")
          | 戦闘開始
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
    };
  },
  store,
  mounted(){
    this.battle = new BattleFactory().getBattle();
  },
  methods: {
    startBattle(){
      this.battle.execute();
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
