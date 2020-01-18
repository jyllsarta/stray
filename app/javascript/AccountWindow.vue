<template lang="pug">
  .menu
    .back(@click="$store.commit('updateWindowShowState', {windowName: 'account', state: false})")
    .window.content.account
      .back_button(@click="$store.commit('updateWindowShowState', {windowName: 'account', state: false})")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Api from './Api'

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
.account{

}
</style>
