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
            | HP：
          .value
            | {{$store.state.user.characters.spica.hp}} / {{$store.state.user.characters.spica.hp_max}}
        .exp
          .label
            | EXP：
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
            | HP：
          .value
            | {{$store.state.user.characters.tirol.hp}} / {{$store.state.user.characters.tirol.hp_max}}
        .exp
          .label
            | EXP：
          .value
            | 13%
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
      width: 4.5rem; // "Lv:12345 "
      border-right: 1px solid $gray2;
      padding-right: $thin_space;
      background-position: center;
      background-size: cover;
      border-radius: $radius 0 0 $radius;
    }
    .gauge {
      width: 100%;
      flex: 1;
      white-space: pre-wrap;
      padding-left: $thin_space;
      display: flex;
      flex-direction: column;
      .hp, .exp{
        width: 100%;
        .label{
          display: inline-block;
          width: 25%;
          text-align: right;
          padding-right: $thin_space;
        }
        .value{
          display: inline-block;
          width: 75%;
        }
      }
    }
  }
}
</style>
