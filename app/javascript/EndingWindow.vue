<template lang="pug">
  .menu
    .full_covered_window(@click="proceed")
      | ぽよお
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      index: 0,
    };
  },
  props: {
  },
  components: {
  },
  store,
  mounted(){
  },
  computed: {
  },
  methods: {
    proceed(){
      this.index++;
      this.$store.commit('window/updateWindowShowState', {windowName: "ending", state: false});
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";

.full_covered_window{
  position: absolute;
  width: $window-width;
  height: $window-height;
  background-color: white;
  opacity: 1;
  padding: $space;
}

</style>
