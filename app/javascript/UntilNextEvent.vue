<template lang="pug">
 .next_event_time
    .label
      | 次回イベントまで
    .content
      | {{$store.state.timer.next_event}}秒
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
    &::after{
      content: "：";
    }
  }
  .content{
    width: 100%;
    height: 60%;
    font-size: 18px;
    padding-top: $space;
    text-align: right;
    line-height: 100%;
  }
}
</style>
