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
        .characters
          img.tirol(src="/images/battle/tirol.png")
          img.spica(src="/images/battle/spica.png")
        .player_magic_list
          MagicList(:isPlayer="true")
        .enemy_magic_list
          MagicList(:isPlayer="false")

</template>

<script lang="ts">
  import Constants from "./packs/constants.ts";
  import store from './packs/store.ts'
  import axios from 'axios'
  import ax from "./packs/axios_default_setting.ts";
  import MagicList from "./MagicList.vue";

  export default {
    components: {
      MagicList
    },
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
    .characters{
      position: absolute;
      bottom: $space + 70px;
      left: $space;
      .spica{
        position: absolute;
        bottom: 0;
        left: 0;
        width: 256px;
        height: 256px;
      }
      .tirol{
        position: absolute;
        bottom: 0;
        left: -50px;
        width: 256px;
        height: 256px;
      }
    }

    .player_magic_list{
      position: absolute;
      bottom: $thin_space;
      left: $thin_space;
    }
    .enemy_magic_list{
      position: absolute;
      bottom: $thin_space;
      right: $thin_space;
    }
  }

</style>
