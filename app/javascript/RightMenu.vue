<template lang="pug">
  .right_menu.window
    .item.clickable
      | 回復
    .item.clickable(
      @mouseover="$store.commit('updateGuide', '装備メニューを表示します。')",
      @click="$store.commit('updateWindowShowState', {windowName: 'equip', state: true})"
    )
      | 装備
    .item.clickable(
      @mouseover="$store.commit('updateGuide', '引き継ぎ関連のメニューを表示します。')",
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
@import "stylesheets/global_setting";
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
    margin-bottom: $thin_space;
    line-height: 100%;
    padding-top: (40px - $font-size-normal) / 2;
    padding-left: $space;
  }
}
</style>
