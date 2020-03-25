<template lang="pug">
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {};
  },
  store,
  watch: {
    // イベント発生時の処理
    "$store.state.event.events": {
      handler: function(events){
        if(events.filter(event=>!event.resolved).length > 0){
          this.showEventIllust(events.slice(-1)[0]);
        }
        // 再生した中にバトルイベントがあったら全部終わったあとにユーザデータを再ロードする
        const hasBattleEvent = events.filter(event=>!event.resolved).filter(event=>event.type === 'battle').length > 0;
        events.filter(event=>!event.resolved).forEach((event)=>{
          this.processEvent(event);
        });
        if(hasBattleEvent){
          this.$store.dispatch("user/fetchUserModel");
        }
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
        this.$store.commit("user/incrementItemRank", {item_id: event.detail.id, amount: event.detail.amount})
      }
      else{
        this.$store.dispatch('user/fetchUserModel');
      }
    },
    resolveBattleEvent(event){
      this.$store.commit("user/applyBattleDamage", event.detail.damages);
    },
    resolveStairEvent(){
      this.$store.commit("user/incrementCurrentDungeonDepth");
    },
    resolveResurrectEvent(event){
      console.log(event);
      if(event.detail.completed){
        this.$store.commit("user/resurrect");
      }
    },
  },
}
</script>

<style lang="scss" scoped>
</style>
