<template lang="pug">
  .right_menu.window
    .item
      | 回復
    .item(
      @click="$store.commit('updateWindowShowState', {windowName: 'equip', state: true})"
    )
      | 装備
    .item
      | ステータス
    .item(
      @click="$store.commit('updateWindowShowState', {windowName: 'account', state: true})"
    )
      | 引き継ぎ設定(仮)
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
.right_menu{
  height: $window-height - $space * 2;
  width: 200px - $space * 3;
  top: $space;
  right: $space;
  display: flex;
  flex-direction: column;
  font-size: $font-size-normal;
  .item{
    width: 100%;
    height: 40px;
    background-color: $clickable-color;
    margin-bottom: $thin_space;
    border-radius: $radius;
    line-height: 100%;
    padding-top: (40px - $font-size-normal) / 2;
    padding-left: $space;
    &:hover{
      filter: brightness(110%);
      transform: scale(1.02);
    }
  }
}
</style>
