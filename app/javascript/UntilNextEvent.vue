<template lang="pug">
 .next_event_time
    .label
      | 次回イベントまで
    .content
      .main
        | {{$store.state.timer.next_event}}
      .sep
        | 秒
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {};
  },
  mounted() {
  },
  store,
  computed: {
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";

.next_event_time{
  .label{
    width: 100%;
    height: 40%;
    font-size: 14px;
    border-bottom: 1px solid $gray3;
  }
  .content{
    width: 100%;
    height: 60%;
    font-size: 18px;
    padding-top: $space;
    text-align: right;
    line-height: 100%;
    .main{
      display: inline-block;
    }
    .sep{
      padding: 0 $subtle_space 0 $subtle_space;
      display: inline-block;
      font-size: $font-size-mini;
    }
  }
}
</style>
