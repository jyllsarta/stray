<template lang="pug">
  .log.window(ref="log", :class="foldClass" @click="folded = !folded")
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
    return {
      folded: true,
    };
  },
  store,
  computed: {
    logs(){
      return this.$store.state.event.events.map(l=>l.logs).flat();
    },
    foldClass(){
      return this.folded ? "folded" : "opened";
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
    scrollToBottom(){
      this.$refs.log.scrollTo(0, this.$refs.log.scrollHeight);
    }
  },
  watch: {
    "logs": {
      handler: function(newVal, oldVal){
        const count = newVal.length - oldVal.length;
        Vue.nextTick(()=>{
          //大雑把にだいたい画面の下の方にいたら下限をキープする
          if(this.$refs.log.scrollHeight - this.$refs.log.scrollTop < 600){
            this.scrollToBottom();
          }
        });
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.folded{
  height: 100px;
}
.opened{
  height: $window-height - 210px - $space * 3;
}
.log{
  width: 300px;
  top: 60px + 80px + 50px + $space * 4;
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
  }

  .show-in-enter-active {
    transition: all .4s;
  }
  .show-in-leave-active {
    transition: all .4s;
  }
  .show-in-enter{
    transform: translateX(-30px);
    opacity: 0;
  }
  .show-in-leave-to{
    transform: translateX(-30px);
    opacity: 0;
  }
}
</style>
