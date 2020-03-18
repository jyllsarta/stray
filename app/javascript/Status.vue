
<template lang="pug">
  .status.window
    .spica
      .profile
        .name
          | スピカ
        .lv
          | Lv:19
      .gauge
        .hp
          .label
            | HP
          .value
            | {{$store.state.user.characters.spica.hp}} / {{$store.state.user.characters.spica.hp_max}}
        .gauge(:style="{width: hpGaugeWidth('spica'), backgroundColor: hpGaugeColor('spica') }")
        .exp
          .label
            | EXP
          .value
            | 85%
    .tirol
      .profile
        .name
          | チロル
        .lv
          | Lv:34445
      .gauge
        .hp
          .label
            | HP
          .value
            | {{$store.state.user.characters.tirol.hp}} / {{$store.state.user.characters.tirol.hp_max}}
        .gauge(:style="{width: hpGaugeWidth('tirol'), backgroundColor: hpGaugeColor('tirol') }")
        .exp
          .label
            | EXP
          .value
            | 13%
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
      character_base_width: 190
    };
  },
  store,
  methods: {
    hpGaugeWidth(characterName){
      return this.hpPercent(characterName) / 100 * this.character_base_width;
    },
    hpPercent(characterName){
      return this.$store.getters['user/getCharacterHpPercent'](characterName)
    },
    hpGaugeColor(characterName){
      const percent = this.hpPercent(characterName);
      return `hsla(${percent / 100 * 220}, 100%, 70%, 1)`
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";

.status{
  height: 80px;
  width: 300px;
  top: 60px + $space * 2;
  left: $space;
  font-size: $font-size-mini;
  display: flex;
  flex-direction: column;
  .spica .profile{
    background: linear-gradient(to right, rgba(0, 0, 0, 0.4) 60%, rgba(0, 0, 0, 1)  100%), url("/images/ui/profile_background_spica.png");
  }
  .tirol .profile{
    background: linear-gradient(to right, rgba(0, 0, 0, 0.4) 60%, rgba(0, 0, 0, 1)  100%), url("/images/ui/profile_background_tirol.png");
  }
  .spica, .tirol {
    width: 100%;
    line-height: 120%;
    display: flex;
    margin-bottom: $thin_space;
    .profile {
      width: 5rem; // "Lv:12345 "
      border-right: 1px solid $gray2;
      padding-right: $thin_space;
      background-position: center;
      background-size: cover;
      border-radius: $radius 0 0 $radius;
    }
    .gauge {
      width: 100%;
      height: 100%;
      white-space: pre-wrap;
      padding-left: $thin_space;
      display: flex;
      flex-direction: column;
      .hp, .exp{
        width: 100%;
        height: 16px;
        .label{
          display: inline-block;
          width: 2rem;
          text-align: right;
          padding-right: $thin_space;
          border-right: 1px solid $gray3;
        }
        .value{
          padding-left: $thin_space;
          display: inline-block;
          width: calc(100% - 2rem);
        }
      }
      .gauge{
        margin-left: 2rem;
        width: 190px;
        background-color: #93baeb;
        height: 1px;
      }
    }
  }
}
</style>
