<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: false})")
        .title
          | 強敵戦・準備
      .description
        | 強敵と戦います。
      .body
</template>

<script lang="ts">
  import Constants from "./packs/constants.ts";
  import store from './packs/store.ts'
  import axios from 'axios'
  import ax from "./packs/axios_default_setting.ts";

  export default {
    data: function () {
      return {
      };
    },
    store,
    mounted(){
    },
    computed: {
    },
    methods: {
    },
  }
</script>

<style lang="scss" scoped>
  @import "stylesheets/global_setting";
  .description{
    padding: $space;
    white-space: pre-wrap;
    border-bottom: 1px solid $gray3;
  }
  .body {
  }
</style>
