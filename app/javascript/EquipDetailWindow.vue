<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: false})")
        .title
          | 装備詳細
      .description
        | #########の詳細画面です。強化ができます。
      .body
        .current_coin
          .icon
            img(src="/images/ui/coin.png")
          .amount
            | {{$store.state.user.status.coin}}


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

  },
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
  .current_coin{
    display: flex;
    width: 30%;
    .icon{
      img{
        width: 32px;
      }
    }
    .amount{
      line-height: 32px;
      font-size: $font-size-large;
    }
  }
}

</style>
