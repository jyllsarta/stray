<template lang="pug">
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {

    };
  },
  props: {
    rootRef: Object,
  },
  store,
  watch: {
    // イベント発生時の処理
    "$store.state.event.events": {
      handler: function(events){
        const lastEvent = events.slice(-1)[0];
        // キャリブレイベとかはstatusないかも
        if(lastEvent.status){
          this.updatePartialUserStatus(lastEvent.status);
        }
        if(this.$store.state.event.eventsQueue.length > 0){
          return;
        }
        this.showEventIllust(lastEvent);
        this.processEvent(lastEvent);
      },
    },
    // イベント発生時の処理
    "$store.state.event.eventsQueue": {
      handler: function(eventsQueue){
        if(eventsQueue.length > 0){
          setTimeout(this.pollEventQueue, 50);
        }
      },
    }
  },
  mounted(){
  },
  methods: {
    updatePartialUserStatus(partialStatus){
      this.$store.commit("user/updateUserModelEventPartial", partialStatus);
    },
    pollEventQueue(){
      if(this.$store.state.event.eventsQueue.length > 0){
        this.$store.commit("event/dequeueEvent");
      }
    },
    showEventIllust(event){
      if(event.type === 'calibrate' || event.type === 'custom'){
        return;
      }
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
          this.resolveStairEvent(event);
          break;
        case "resurrect":
          this.resolveResurrectEvent(event);
          break;
        case "boss_battle":
          this.resolveBossBattleEvent(event);
          break;
        case "calibrate":
          console.log("pass!"); // ログにだけ流れればそれでOK
          break;
        case "custom":
          break;
        default:
          console.warn(`undefined event type: ${event.type}`);
          break;
      }
    },
    resolveItemEvent(event){
      if(this.$store.state.user.items[event.detail.id]){
        this.$store.commit("user/updateItemRank", {item_id: event.detail.id, rank: event.detail.rank})
      }
      else{
        this.$store.dispatch('user/fetchUserModel');
      }
    },
    resolveBattleEvent(event){
      // かつてキャラモデルを取り直してたけど、部分的ユーザモデル更新で不要になった
    },
    resolveStairEvent(event){
      this.$store.commit("user/updateCurrentDungeonProgress", event.detail.max_depth_dug);
      setTimeout(()=>{
        this.rootRef.field.reseedScene();
      }, 2000);
    },
    resolveResurrectEvent(event){
      if(event.detail.completed){
        this.$store.commit("user/resurrect");
      }
    },
    resolveBossBattleEvent(event){
      // かつてキャラモデルを取り直してたけど、部分的ユーザモデル更新で不要になった
    },
  },
}
</script>

<style lang="scss" scoped>
</style>
