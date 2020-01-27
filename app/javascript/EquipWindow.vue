<template lang="pug">
  .menu
    .back(@click="$store.commit('updateWindowShowState', {windowName: 'equip', state: false})")
    .window.content
      .title_area
        .back_button(@click="$store.commit('updateWindowShowState', {windowName: 'equip', state: false})")
        .title
          | 装備
      .body
        .sub_chara
          img.sub_character_image(src="images/ui/tirol.png")
        .chara
          img.character_image(src="images/ui/spica.png")
        .reinforcements.block
          .label
            | 加護
          .reinforcement_list
            .reinforcement
              | 先制Lv2
            .reinforcement
              | 雷光Lv4
        .sub_chara_status.block
          .label
            | チロルのステータス
          .status
            .atk
              | ATK: 351287952
            .atk
              | DEF: 659998714
        .item_list_main.block
          .label
            | アイテム
        .detail.block
          .label
            | 詳細
        .main_chara_equips.block
          .label
            | スピカのステータス
          .main
            .equips
              .equip
                | ★やさしいなんでもない系装備+878763
              .equip
                | ★やさしいなんでもない系装備+878763
              .equip
                | ★やさしいなんでもない系装備+878763
              .equip
                | ★やさしいなんでもない系装備+878763
            .current_parameters
              .status
                | STR 987654321
              .status
                | STR 987654321
              .status
                | STR 987654321
              .status
                | STR 987654321
            .this_item
              .status
                | +987654321
              .status
                | +987654321
              .status
                | +987654321
              .status
                | +987654321
            .to_status
              .status
                | ATK: 987654321
              .status_diff
                | (+987654321)
              .status
                | DEF: 987654321
              .status_diff
                | (+987654321)


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

// 通常のスタイル定義
.body{
  .block{
    border-left: 1px solid $gray3;
    //border-radius: $radius;
  }

  .label{
    font-size: $font-size-large;
    color: $accent-color;
    line-height: 100%;
  }
  .character_image{
    width: 220px;
    transform: scale(-1,1);
  }
  .sub_character_image{
    width: 160px;
  }

  .reinforcements{
    .reinforcement_list{
      display: flex;
      flex-direction: column;
      padding: $thin_space;
      .reinforcement{
        margin: $thin_space;
        border-bottom: 1px solid $gray3;
        width: 45%;
        text-align: center;
        &::before{
          content: "◇";
        }
      }
    }
  }

  .sub_chara_status{
    font-size: $font-size-mini;
  }

  .main_chara_equips{
    .main{
      display: flex;
      flex-direction: row;
      height: calc(100% - #{$font-size-large});
      .equips{
        width: 45%;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        .equip{
          padding: 2px;
          &:nth-child(1){
            padding-left: 8px;
          }
          &:nth-child(2){
            padding-left: 16px;
          }
          &:nth-child(3){
            padding-left: 24px;
          }
          &:nth-child(4){
            padding-left: 32px;
          }
        }
      }
    }
  }
}


// 箱自体の配置
// 頭がおかしくなりそうなんだけどこういうのの配置って通常どうなってるんです？

$detail-width: 150px;
$character-width: 200px;
$character-height: 320px;
$sub-character-width: 100px;
$sub-character-height: 170px;
$main-chara-equip-height: 170px;
$item_list-main-width:400px;
$reinforcement-list-height: 200px;

.body{
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
  .sub_chara_status{
    position: absolute;
    top: $reinforcement-list-height + $thin_space * 2;
    left: $character-width;
    width: calc(100% - #{$item_list-main-width} - #{$detail-width} - #{$character-width} - #{$thin_space * 3});
    height: calc(100% - #{$main-chara-equip-height} - #{$reinforcement-list-height} - #{$thin_space * 5});
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
