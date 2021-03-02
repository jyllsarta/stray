<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'gacha', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'gacha', state: false})")
          .arrow
        .title
          | 神秘の鍋
      .description
        | コインを投入して、溢れてくる何かを掴み取りましょう。
      .body
        .rates
          | 提供割合：
        .coins
          | XXXXXX,XXX
        .rewards
          | ご利益
        .pot
          | ポット
        .characters
          | スピカチロル耳

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import StateLibrary from './packs/quest/state_library'

export default {
  data: function () {
    return {
    };
  },
  props: {
  },
  store,
  mounted(){
  },
  computed: {
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
  .description{
    padding: $space;
    white-space: pre-wrap;
    border-bottom: 1px solid $gray3;
  }
  .body{
    width: 100%;
    height: 80%;
    *{
      outline: 1px solid $yellow;
    }
    .rates{
      position: absolute;
      top: 100px;
      left: $space;
      width: 200px;
      height: 400px;
    }
    .rewards{
      position: absolute;
      top: 100px;
      right: $space;
      width: 200px;
      height: 400px;
    }
    .coins{
      position: absolute;
      top: 100px;
      $width: 400px;
      left: calc((100% - #{$width}) / 2);
      width: $width;
      height: 150px;
    }
    .pot{
      position: absolute;
      bottom: 100px;
      $width: 500px;
      left: calc((100% - #{$width}) / 2);
      width: $width;
      height: 150px;
    }
    .characters{
      position: absolute;
      bottom: $space;
      $width: 600px;
      left: calc((100% - #{$width}) / 2);
      width: $width;
      height: 100px;
    }
  }
</style>
