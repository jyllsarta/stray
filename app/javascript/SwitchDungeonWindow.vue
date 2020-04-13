<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'switch_dungeon', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'switch_dungeon', state: false})")
        .title
          | ダンジョン切り替え
      .description
        | 行ったことのあるダンジョンに戻ったり、新しいダンジョンに挑めます。
      .body
        .dungeon_list_tab
          .dungeon
            .name
              | 1個めのダンジョン
            .progress
              | 403 / 400F
          .dungeon
            .name
              | 2個めのダンジョン
            .progress
              | 1871 / 1200F
          .dungeon
            .name
              | 3個めのダンジョン
            .progress
              | 1 / 1600F
        .control_tab
          .main_image
            img(src="images/events/battle.png")
          .controls.window
            .depth_slider
              input(type="range" orient="vertical")
            .go.button.clickable
              | Go!
            .go_to_floor
              | 13558F
            .go_to_floor_label
              | 移動先：
            .top_floor
              | 1F
            .deepest_floor
              | 1200F
            .descriptions
              .title
                | 霧の森
              .description
                | 霊力を帯びた霧の立ち込める森。森の主である巨大な蛇は *絶えず霊力を放出し続けるマジックアイテム* を持ってるとか。大陸踏破に直接は関係ないけど、探索に役立つものを手に入れられるかもしれない。推奨RANK:40
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
    display: flex;
  }
  .dungeon_list_tab{
    padding: $space;
    display: flex;
    flex-direction: column;
    height: 430px;
    width: 380px;
    .dungeon{
      padding: $space;
      width: 100%;
      .name{
        display: inline-block;
        width: 60%;
      }
      .progress{
        display: inline-block;
        width: 40%;
        text-align: right;
      }
    }
  }
  .control_tab{
    .main_image{
      img{
        padding: $space;
        width: 600px;
        height: 200px;
      }
    }
    .controls{
      margin-top: $space;
      position: relative;
      height: 232px;
      .depth_slider{
        position: absolute;
        top: $space;
        left: 70px;
        width: 20px;
        height: 210px;
        input{
          width: 100%;
          height: 100%;
          -webkit-appearance: slider-vertical;
        }
      }
      .go{
        position: absolute;
        bottom: $space;
        right: $space;
        width: 100px;
        height: 50px;
        line-height: 100%;
        font-size: $font-size-large;
        text-align: center;
        padding-top: (50px - $font-size-large) / 2;
      }
      .go_to_floor{
        position: absolute;
        bottom: $space;
        right: 120px;
        font-size: $font-size-large;
      }
      .go_to_floor_label{
        position: absolute;
        bottom: $font-size-large + $space * 2;
        right: 120px;
        width: 100px;
        font-size: $font-size-mini;
      }
      .top_floor{
        position: absolute;
        top: $space;
        left: 100px;
      }
      .deepest_floor{
        position: absolute;
        bottom: $space;
        left: 100px;
      }
      .descriptions{
        position: absolute;
        top: $space;
        right: $space;
        width: 70%;
        .title{
          padding-left: $space;
          font-size: $font-size-large;
          border-bottom: 1px solid $gray3;
        }
        .description{
          font-size: $font-size-mini;
        }
      }
    }
  }
</style>
