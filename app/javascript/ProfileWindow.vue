<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'profile', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'profile', state: false})")
        .title
          | 〜　冒険のあゆみ　〜
      .body
        .spica.character
          img(src="/images/characters/spica.png")
        .main
          .total_rank
            .judgement
              .key
                | トータル冒険評価
              .value
                | SS+
            .details
              .detail
                .key
                  | 累計コイン獲得数
                .value
                  | 1234567890
              .detail
                .key
                  | 実績クリア数
                .value
                  | 144
              .detail
                .key
                  | 討伐済みの敵
                .value
                  | 36
              .detail
                .key
                  | アイテム収集数
                .value
                  | 1131
              .detail
                .key
                  | 能力解放数
                .value
                  | 88
              .detail
                .key
                  | 総ログイン時間
                .value
                  | 11日 13:44:12
              .detail
                .key
                  | イベントプレイ数
                .value
                  | 1234567
              .detail
                .key
                  | 最高到達階
                .value
                  | 4884312F
          .hr
          .strengthes
            .strength.spica
              .chunk.equips
                .equip
                  | にぎにぎ+4
                .equip
                  | ◆銀のうなぎ+41
                .equip
                  | ◆はてなようせい+111
                .equip
                  | *スリセルのロザリオ
              .chunk.statuses
                .status
                  .key
                    | STR
                  .value
                    | 41
                .status
                  .key
                    | DEX
                  .value
                    | 33
                .status
                  .key
                    | DEF
                  .value
                    | 9875
                .status
                  .key
                    | AGI
                  .value
                    | 2231
            .strength.tirol
              .chunk.equips
                .equip
                  | ◆銀色の狂戦士のコップ+987987
                .equip
                  | ◆狂戦士のコップ+987987
                .equip
                  | ◆狂戦士のコップ+987987
                .equip
                  | ◆狂戦士のコップ+987987
              .chunk.statuses
                .status
                  .key
                    | STR
                  .value
                    | 976534678
                .status
                  .key
                    | DEX
                  .value
                    | 976534678
                .status
                  .key
                    | DEF
                  .value
                    | 976534678
                .status
                  .key
                    | AGI
                  .value
                    | 976534678
        .tirol.character
          img(src="/images/characters/tirol.png")

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
  * {
    //outline: 1px solid #79f850;
  }
  .window{
    .title_area{
      .title{
        width: 82%;
        text-align: center;
      }
    }
    overflow: hidden;
  }
  .hr{
    height: 1px;
    width: 100%;
    background-color: $gray3;
  }
  .body{
    display: flex;
    padding-top: 2%;
    height: 90%;
    .character{
      width: 20%;
      height: 100%;
      z-index: 100;
      img{
        margin-top: 20%;
        height: 90%;
      }
    }
    .main{
      width: 60%;
      height: 100%;
      z-index: 200;
      display: flex;
      flex-direction: column;
      line-height: 160%;
      .strengthes{
        display: flex;
        .spica{
        }
        .tirol{
          .equips{
            .equip{
              text-align: right;
            }
          }
          .statuses{
            .status{
              text-align: right;
            }
          }
        }
        .strength{
          width: 50%;
          .equips{
            .equip{
              background-color: $background_with_opacity;
              border-radius: $radius;
            }
          }
          .statuses {
            .status {
              background-color: $background_with_opacity;
              border-radius: $radius;
              .key, .value {
                display: inline-block;
                width: 100%;
              }
              .key{
                width: 15%;
              }
              .value{
                width: 60%;
              }
            }
          }
        }
      }
      .total_rank{
        line-height: 150%;
        .judgement{
          width: 100%;
          .key, .value{
            width: 100%;
            text-align: center;
          }
          .key{
            font-size: $font-size-normal;
          }
          .value{
            font-size: $font-size-large;
          }
        }
        .details{
          display: flex;
          flex-wrap: wrap;
          width: 100%;
          .detail{
            width: 50%;
            .key, .value{
              display: inline-block;
            }
            .key{
              width: 60%;
              text-align: right;
              padding-right: 2%;
            }
            .value{
              width: 38%;
            }
          }
        }
      }
    }
  }
</style>
