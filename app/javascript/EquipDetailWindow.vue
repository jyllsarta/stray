<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: false})")
        .title
          | 装備詳細

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
</style>
