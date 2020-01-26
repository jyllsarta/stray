<template lang="pug">
  .log.window
    .item(v-for="log in logs")
      .at
        | {{composeTime(log.at)}}
      .content
        | {{log.message}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {};
  },
  store,
  computed: {
    logs(){
      // TODO: ログ件数の最大値をConstantsで規定する
      return this.$store.state.event.events.map(l=>l.logs).flat();
    },
  },
  methods: {
    formatZero(int){
      return ("0" + int).slice(-2);
    },
    composeTime(at){
      const date = new Date(at * 1000);
      return `${this.formatZero(date.getHours())}:${this.formatZero(date.getMinutes())}`
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.log{
  height: $window-height - 140px - $space * 4;
  width: 300px;
  bottom: $space;
  left: $space;
  display: flex;
  flex-direction: column;
  font-size: $font-size-mini;
  .item{
    width: 100%;
    line-height: 120%;
    display: flex;
    margin-bottom: $thin_space;
    .at{
      width: 3rem; // "11:33 " ぶんのスペース
      border-right: 1px solid $gray2;
      padding-right: $thin_space;
    }
    .content{
      display: inline-block;
      width: 100%;
      flex: 1;
      white-space: pre-wrap;
      padding-left: $thin_space;
    }
    &:hover{
      filter: brightness(110%);
    }
  }
}
</style>
