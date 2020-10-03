
<template lang="pug">
  .status.window
    .spica
      .profile
        .name
          | スピカ
        .lv
          | Lv:{{$store.state.user.characters.spica.level}}
      .gauge
        .hp
          .label
            | HP
          .value
            NumeratableNumber(:number="spicaHp")
            .sep
              | /
            .number
              | {{$store.state.user.characters.spica.hp_max}}
        .gauge(:style="{width: hpGaugeWidth('spica'), backgroundColor: hpGaugeColor('spica') }")
        .exp
          .label
            | EXP
          .value
            | {{Math.floor($store.state.user.characters.spica.exp / expMax * 100) || 0}}%
        .gauge(:style="{width: expGaugeWidth('spica'), backgroundColor: expGaugeColor('spica') }")
    .tirol
      .profile
        .name
          | チロル
        .lv
          | Lv:{{$store.state.user.characters.tirol.level}}
      .gauge
        .hp
          .label
            | HP
          .value
            NumeratableNumber(:number="tirolHp")
            .sep
              | /
            .number
              | {{$store.state.user.characters.tirol.hp_max}}
        .gauge(:style="{width: hpGaugeWidth('tirol'), backgroundColor: hpGaugeColor('tirol') }")
        .exp
          .label
            | EXP
          .value
            | {{Math.floor($store.state.user.characters.tirol.exp / expMax * 100) || 0}}%
        .gauge(:style="{width: expGaugeWidth('tirol'), backgroundColor: expGaugeColor('tirol') }")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import NumeratableNumber from "./NumeratableNumber.vue";

export default {
  data: function () {
    return {
      character_base_width: 190
    };
  },
  components: {
    NumeratableNumber,
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
    },
    expGaugeWidth(characterName){
      return this.expPercent(characterName) / 100 * this.character_base_width;
    },
    expPercent(characterName){
      return Math.floor(this.$store.state.user.characters[characterName]['exp'] / this.expMax * 100) || 0
    },
    expGaugeColor(characterName){
      const percent = this.expPercent(characterName);
      return `hsla(${percent / 100 * 130 + 90}, 100%, 70%, 1)`
    }
  },
  computed: {
    expMax(){
      return Constants.character.expMax;
    },
    spicaHp(){
      return this.$store.state.user.characters.spica.hp || 0;
    },
    tirolHp(){
      return this.$store.state.user.characters.tirol.hp || 0;
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
          div{
            display: inline-block;
          }
          .sep{
            width: 1em;
            text-align: center;
          }
        }
      }
      .gauge{
        margin-left: 2rem;
        width: 190px;
        background-color: #93baeb;
        height: 0.3px;
      }
    }
  }
}
</style>
