<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle', state: false})")
        .title
          | バトル！
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import BattleFacade from "./packs/quest/battle_facade"


export default {
  data: function () {
    return {
    };
  },
  store,
  mounted(){
    const bat = new BattleFacade();
    bat.newBattle();
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
</style>
