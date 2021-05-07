<template lang="pug">
 .rest_event_times
    .label
      | 不在時イベント再生
    .content
      .main
        | {{restSeconds}}
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
    restSeconds(){
      return Math.floor(((new Date() - this.$store.getters["event/pseudoCurrentTime"]) / 1000));
    }
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";

.rest_event_times{
  width: 100%;
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
    color: $yellow;
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
