<template lang="pug">
  #app
    Guide
    .game
      Field
      Header
      RightMenu
      Status
      Log
      Chat
      EventIllust
      transition(name="open_window")
        AccountWindow(v-if="$store.state.window.account")
      transition(name="open_window")
        EquipWindow(v-if="$store.state.window.equip")
      Api(ref="api")
      Timer
    MessageForm
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Api from './Api'
import Guide from './Guide'
import Field from './Field'
import Header from './Header'
import RightMenu from './RightMenu'
import Log from './Log'
import Status from './Status'
import Chat from './Chat'
import EventIllust from './EventIllust'
import AccountWindow from './AccountWindow'
import EquipWindow from './EquipWindow'
import Timer from './Timer'
import MessageForm from './MessageForm'

export default {
  data: function () {
    return {};
  },
  store,
  components: {
    Api,
    Guide,
    Field,
    Header,
    RightMenu,
    Log,
    Status,
    Chat,
    EventIllust,
    AccountWindow,
    EquipWindow,
    Timer,
    MessageForm,
  },
  mounted(){
    const x = null;
    console.log(x?.a);
  },
  watch: {
    // イベント発生時の処理
    // なーんかダーティな書き方な気がしてならないけど、とりあえず他に方法が思いつかなかったのでこれで
    "$store.state.event.events": {
      handler: function(events){
        if(events.filter(event=>!event.resolved).length > 0){
          this.showEventIllust(events.slice(-1)[0]);
        }
        events.filter(event=>!event.resolved).forEach((event)=>{
          this.processEvent(event);
        });
      },
    }
  },
  methods: {
    showEventIllust(event){
      this.$store.commit("event_illust/showEventIllust", event.type);
    },
    processEvent(event){
      switch (event.type) {
        case "item":
          this.resolveItemEvent(event);
          break;
        case "battle":
          this.resolveBattleEvent(event);
          break;
        case "stair":
          this.resolveStairEvent();
          break;
        case "resurrect":
          this.resolveResurrectEvent(event);
          break;
        default:
          console.warn(`undefined event type: ${event.type}`);
          break;
      }
      event.resolved = true;
    },
    resolveItemEvent(event){
      if(this.$store.state.user.items[event.detail.id]){
        this.$store.commit("incrementItemRank", {item_id: event.detail.id, amount: event.detail.amount})
      }
      else{
        // この親子関係があるからなんとかなってるけど、どっからでもAPIを呼べるようにならないといつか困る予感
        this.$refs.api.fetchUserModel();
      }
    },
    resolveBattleEvent(event){
      this.$store.commit("applyBattleDamage", event.detail.damages);
    },
    resolveStairEvent(){
      this.$store.commit("incrementCurrentDungeonDepth");
    },
    resolveResurrectEvent(event){
        console.log(event);
        if(event.detail.completed){
        this.$store.commit("resurrect");
      }
    },
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
</style>
