<template lang="pug">
  .velocity.window
    | {{velocity}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Vue from 'vue'

export default {
  data: function () {
    return {
    };
  },
  store,
  computed: {
    velocity(){
      return this.$store.state.user.status.velocity;
    }
  },
  methods: {
  },
  watch: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.velocity {
  width: 300px;
  top: 60px + 80px + $space * 3;
  left: $space;
  height: 40px;
}
</style>
