<template lang="pug">
  .log.window
    .item
      .at
        | 11:22
      .content
        | ☆神殺しの彗星のアミュレット+65535を拾った！
    .item
      .at
        | 23:55
      .content
        | ★食品サンプルを拾った！
    .item
      .at
        | 7:06
      .content
        | 野うさぎ4体との戦闘だ！
        | HP: (80,54)→(66,13) / 4ターン
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {};
  },
  store,
  mounted(){
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.log{
  height: 600px - 140px - $space * 4;
  width: 300px;
  bottom: $space;
  left: $space;
  display: flex;
  flex-direction: column;
  font-size: $font-size-mini;
  .item{
    width: 100%;
    line-height: 120%;
    display: flex;
    margin-bottom: $thin_space;
    .at{
      width: 3rem; // "11:33 " ぶんのスペース
      border-right: 1px solid $gray2;
      padding-right: $thin_space;
    }
    .content{
      display: inline-block;
      width: 100%;
      flex: 1;
      white-space: pre-wrap;
      padding-left: $thin_space;
    }
    &:hover{
      filter: brightness(110%);
    }
  }
}
</style>
