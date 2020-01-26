<template lang="pug">
  .menu
    .back(@click="$store.commit('updateWindowShowState', {windowName: 'equip', state: false})")
    .window.content
      .title_area
        .back_button(@click="$store.commit('updateWindowShowState', {windowName: 'equip', state: false})")
        .title
          | 装備
      .body
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
</style>
