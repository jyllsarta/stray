<template lang="pug">
  #app
    Field
    Header
    RightMenu
    Status
    Chat
    Log
    AccountWindow(v-if="$store.state.ui.window.account")
    Api
    Timer
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Api from './Api'
import Field from './Field'
import Header from './Header'
import RightMenu from './RightMenu'
import Log from './Log'
import Status from './Status'
import Chat from './Chat'
import AccountWindow from './AccountWindow'
import Timer from './Timer'

export default {
  data: function () {
    return {};
  },
  store,
  components: {
    Api,
    Field,
    Header,
    RightMenu,
    Log,
    Status,
    Chat,
    AccountWindow,
    Timer,
  },
  watch: {
    // イベント発生時の処理
    // なーんかダーティな書き方な気がしてならないけど、とりあえず他に方法が思いつかなかったのでこれで
    "$store.state.event.events": {
      handler: function(events){
        events.filter(event=>!event.resolved).forEach((event)=>{
          this.processEvent(event);
        });
      },
    }
  },
  methods: {
    processEvent(event){
      switch (event.type) {
        case "Item":
          this.resolveItemEvent(event);
          break;
        case "Battle":
          break;
        case "Stair":
          break;
        default:
          console.warn(`undefined event type: ${event.type}`);
          break;
      }
      event.resolved = true;
    },
    resolveItemEvent(event){
      this.$store.commit("incrementItemRank", {item_id: event.detail.id, amount: event.detail.amount})
    }
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
</style>
