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
        .enemy_character
          img.enemy(src="/images/battle/enemy.png")
        .player_magic_list
          MagicList(:isPlayer="true")
        .enemy_magic_list
          MagicList(:isPlayer="false")
        .battle_start.clickable(@click="startBattle")
          | 戦闘開始
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
        selectingEnemyId: 1,
      };
    },
    store,
    mounted(){
    },
    computed: {
    },
    methods: {
      startBattle(){
        this.$store.commit("battle/setEnemyId", this.selectingEnemyId);
        this.$store.commit("window/updateWindowShowState", {windowName: "battle", state: true})
      }
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

    .enemy_character{
      position: absolute;
      bottom: $space + 70px;
      right: $space;
      .enemy{
        width: 256px;
        height: 256px;
      }
    }

    .battle_start{
      position: absolute;
      bottom: 80px;
      left: calc((100% - 150px) / 2);
      width: 150px;
      height: 50px;
      padding-top: (50px - $font-size-normal) / 2;
      line-height: 100%;
      text-align: center;
    }
  }
</style>
