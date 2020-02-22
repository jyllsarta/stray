<template lang="pug">
  .log.window(ref="log")
    transition-group(name="show-in")
      .item(v-for="log in logs", :key="'' + log.pseudo_id + log.at")
        .at
          | {{composeTime(log.at)}}
        .content
          | {{log.message}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Vue from 'vue'

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
    },
    scroll(delta){
      this.$refs.log.scrollBy(0, delta);
    }
  },
  watch: {
    "logs": {
      handler: function(newVal, oldVal){
        const count = newVal.length - oldVal.length;
        Vue.nextTick(()=>{
          //大雑把にだいたい画面の下の方にいたらスクロールする
          if(this.$refs.log.scrollHeight - this.$refs.log.scrollTop < 600){
            this.scroll(count * 50);
          }
        });
      }
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
  overflow-y: scroll;
  &::-webkit-scrollbar{
    width: 10px;
  }
  &::-webkit-scrollbar-track{
    background: transparent;
    border: none;
    border-radius: $radius;
    box-shadow: inset 0 0 2px #777;
  }
  &::-webkit-scrollbar-thumb{
    background: $gray2;
    border-radius: $radius;
    box-shadow: none;
  }
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

  .show-in-enter-active {
    transition: all .1s;
  }
  .show-in-leave-active {
    transition: all .1s;
  }
  .show-in-enter{
    transform: translateX(0px);
    opacity: 0;
  }
  .show-in-leave-to{
    transform: translateX(0px);
    opacity: 0;
  }
}
</style>
