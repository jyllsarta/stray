<template lang="pug">
  .magic_list(:class="sideClass")
    .magic
      .name
        | プロテクト
      .cost
        | 40∞
    .magic
      .name
        | 雷撃
      .cost
        | 70∞
    .magic
      .name
        | 必殺 -桜花-
      .cost
        | 100
    .magic
      .name
        | 霊撃
      .cost
        | 100
    .magic
      .name
        | 応急治療
      .cost
        | 40
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

    };
  },
  props: {
    isPlayer: Boolean,
  },
  store,
  mounted(){
  },
  computed: {
    sideClass(){
      return this.isPlayer ? "player_magic_list" : "enemy_magic_list";
    }
  },
  methods: {
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";

.magic_list{
  display: flex;
  .magic{
    margin: $thin_space / 2;
    padding: $thin_space / 2;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    border: 1px solid $gray3;
    border-radius: $radius;
    width: 90px;
    height: 60px;
    .name, .cost{
      text-align: center;
    }
  }
}

.player_magic_list{
  justify-content: flex-start;
}

.enemy_magic_list{
  justify-content: flex-end;
}

// -- -- --

// ウィンドウ位置定義

// -- -- --

.player_magic_list{
  position: absolute;
  top: 480px;
  left: $space;
  width: 500px;
  height: 65px;
}
.enemy_magic_list{
  position: absolute;
  top: 480px;
  right: $space;
  width: 500px;
  height: 65px;
}
</style>
