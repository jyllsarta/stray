<template lang="pug">
  .menu
    .back(@click="$store.commit('updateWindowShowState', {windowName: 'equip', state: false})")
    .window.content
      .title_area
        .back_button(@click="$store.commit('updateWindowShowState', {windowName: 'equip', state: false})")
        .title
          | 装備
      .body
        .chara
          | メインキャラ
        .sub_chara
          | サブキャラ
        .reinforcements
          | 加護一覧
        .sub_chara_equips
          | サブキャラの装備メニュー
        .sub_chara_status
          | サブキャラのステ
        .item_list_main
          | メインの装備リスト
        .detail
          | 選択中アイテムの詳細
        .main_chara_equips
          | メインキャラの装備メニュー

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'

export default {
  data: function () {
    return {
    };
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

// 頭がおかしくなりそうなんだけどこういうのの配置って通常どうなってるんです？

$detail-width: 150px;
$character-width: 200px;
$character-height: 400px;
$sub-character-width: 100px;
$sub-character-height: 200px;
$main-chara-equip-height: 170px;
$item_list-main-width:400px;
$reinforcement-list-height: 200px;
$sub-chara-status-height: 40px;

  .body{
    *{
      background-color: $gray2;
    }
    .chara{
      position: absolute;
      bottom: $thin_space;
      left: $thin_space;
      width: $character-width - $thin_space * 2;
      height: $character-height;
    }
    .sub_chara{
      position: absolute;
      bottom: 250px;
      left: 80px;
      width: $sub-character-width;
      height: $sub-character-height;
    }
    .reinforcements{
      position: absolute;
      top: $thin_space;
      left: $character-width;
      width: calc(100% - #{$item_list-main-width} - #{$detail-width} - #{$character-width} - #{$thin_space * 3});
      height: $reinforcement-list-height;
    }
    .sub_chara_equips{
      position: absolute;
      top: $reinforcement-list-height + $sub-chara-status-height + $thin_space * 3;
      left: $character-width;
      width: calc(100% - #{$item_list-main-width} - #{$detail-width} - #{$character-width} - #{$thin_space * 3});
      height: calc(100% - #{$main-chara-equip-height} - #{$reinforcement-list-height} - #{$sub-chara-status-height} - #{$thin_space * 5});
    }
    .sub_chara_status{
      position: absolute;
      top: $reinforcement-list-height + $thin_space * 2;
      left: $character-width;
      width: calc(100% - #{$item_list-main-width} - #{$detail-width} - #{$character-width} - #{$thin_space * 3});
      height: $sub-chara-status-height;
    }
    .item_list_main{
      position: absolute;
      top: $thin_space;
      right: $detail-width + $thin_space * 2;
      width: $item-list-main-width;
      height: calc(100% - #{$main-chara-equip-height} - #{$thin_space * 3});
    }
    .detail{
      position: absolute;
      top: $thin_space;
      right: $thin_space;
      width: $detail-width;
      height: calc(100% - #{$main-chara-equip-height} - #{$thin_space * 3});
    }
    .main_chara_equips{
      position: absolute;
      bottom: $thin_space;
      right: $thin_space;
      width: calc(100% - #{$character-width} - #{$thin_space});
      height: $main-chara-equip-height;
    }
  }
</style>
