<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'profile', state: false})")
    .window.content
      .title_area
        .back_button.clickable(
          @click="$store.commit('window/updateWindowShowState', {windowName: 'profile', state: false})"
          @mouseover="$store.commit('guide/updateGuide', 'ウィンドウを閉じる。')"
        )
          .arrow
        .title
          | 〜　冒険のあゆみ　〜
      .body
        .character
          img.spica(src="/images/characters/spica.png")
        .main
          .total_rank
            .judgement
              .key
                | トータル冒険評価
              .value
                | SS+
            .details
              .detail.list_item_large(@mouseover="$store.commit('guide/updateGuide', 'ゲームを開始してから累計で獲得したコイン枚数。')")
                .key
                  | 累計コイン獲得数
                .value
                  | {{profile.achievements.total_coin}}
              .detail.list_item_large(@mouseover="$store.commit('guide/updateGuide', 'ゲームを開始してから累計でクリアした実績の総数。')")
                .key
                  | 実績クリア数
                .value
                  | {{profile.achievements.cleared_achievements}}
              .detail.list_item_large(@mouseover="$store.commit('guide/updateGuide', 'ゲームを開始してからクエストで倒した敵の種類の数。')")
                .key
                  | 討伐済みの敵
                .value
                  | {{profile.achievements.won_enemy_count}}
              .detail.list_item_large(@mouseover="$store.commit('guide/updateGuide', 'ゲームを開始してから累計で獲得したアイテムの種類の数。')")
                .key
                  | アイテム収集数
                .value
                  | {{profile.achievements.unique_item_count}}
              .detail.list_item_large(@mouseover="$store.commit('guide/updateGuide', 'ゲームを開始してから累計で解放した能力の数。')")
                .key
                  | 能力解放数
                .value
                  | {{profile.achievements.relics}}
              .detail.list_item_large(@mouseover="$store.commit('guide/updateGuide', 'ゲームを開始してから、ウィンドウをつけっぱなしにした時間。')")
                .key
                  | 総ログイン時間
                .value
                  | {{playTimeString}}
              .detail.list_item_large(@mouseover="$store.commit('guide/updateGuide', 'ゲームを開始してから累計で発生したイベント数。')")
                .key
                  | イベントプレイ数
                .value
                  | {{profile.achievements.total_event}}
              .detail.list_item_large(@mouseover="$store.commit('guide/updateGuide', '一番遠くまで行った階層。')")
                .key
                  | 最高到達階
                .value
                  | {{profile.achievements.deepest_floor}}F
          .strengthes
            .strength.spica
              .equips
                .equip.character_equip(v-for="equip in profile.equips.spica" :class="`rarity${equip.rarity}`")
                  | {{equip.name}}
                .equip.character_equip(v-for="_e in new Array(maxEquipCount - profile.equips.spica.length)")
                  | -
              .statuses
                .status.list_item_medium(v-for="param in ['str', 'dex', 'def', 'agi']")
                  .key
                    | {{param.toUpperCase()}}
                  .value
                    | {{profile.parameters.spica[param]}}
            .strength.tirol
              .equips
                .equip.character_equip(v-for="equip in profile.equips.tirol" :class="`rarity${equip.rarity}`")
                  | {{equip.name}}
                .equip.character_equip(v-for="_e in new Array(maxEquipCount - profile.equips.tirol.length)")
                  | -
              .statuses
                .status.list_item_medium(v-for="param in ['str', 'dex', 'def', 'agi']")
                  .key
                    | {{param.toUpperCase()}}
                  .value
                    | {{profile.parameters.tirol[param]}}
        .character
          img.tirol(src="/images/characters/tirol.png")

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      profile: {
        achievements:{
          total_play_time: 0,
        },
        equips: {
          spica: [],
          tirol: [],
        },
        parameters: {
          spica: [],
          tirol: [],
        },
      },
      maxEquipCount: Constants.maxEquipCount,
    };
  },
  props: {
  },
  store,
  mounted(){
    this.fetchProfile();
  },
  computed: {
    playTimeString(){
      const seconds = this.profile.achievements.total_play_time;
      const hour = Math.floor(seconds / 60 / 60);
      const minutes = Math.floor(seconds % 3600 / 60);
      return `${hour}h${minutes}m`
    }
  },
  methods: {
    fetchProfile(){
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/profile.json`;
      ax.get(path)
        .then((results) => {
          console.log(results);
          this.profile = results.data.profile;
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
  * {
    //outline: 1px solid #79f850;
  }

  .rarity1{
    color: $rarity1;
  }
  .rarity2{
    color: $rarity2;
  }
  .rarity3{
    color: $rarity3;
  }
  .rarity4{
    color: $rarity4;
  }
  .rarity5{
    color: $rarity5;
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
    height: 92%;
    .character{
      width: 16%;
      height: 100%;
      z-index: 100;
      img{
        margin-top: 20%;
        height: 90%;
      }
      .tirol{
        position: relative;
        left: -40px;
      }
    }
    .main{
      width: 68%;
      height: 100%;
      z-index: 200;
      display: flex;
      flex-direction: column;
      .strengthes{
        display: flex;
        .tirol{
          .equips{
            .equip{
              text-align: right;
            }
          }
        }
        .strength{
          width: 50%;
          .equips{
            .equip{
              background-color: $background;
              width: calc(100% - #{$thin_space} * 3);
              margin: $subtle_space;
            }
          }
          .statuses {
            display: flex;
            flex-wrap: wrap;
            .status {
              margin: $subtle_space;
              width: calc(50% - #{$subtle_space} * 3);
              .key, .value {
                display: inline-block;
              }
              .key{
                width: 25%;
              }
              .value{
                width: 70%;
                text-align: right;
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
            margin: $thin_space;
            width: calc(50% - #{$thin_space} * 3);
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
