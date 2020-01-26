<template lang="pug">
  .header.window
    .clock.header_content
      .label
        | 時刻
      .content
        | 1月12日 15:46:33
    .next_event_time.header_content
      .label
        | 次回イベントまで
      .content
        | {{eventTimer}}秒
    .dungeon_name.header_content
      .label
        | 現在地
      .content
        | 翠海の輝浜
    .dungeon_depth.header_content
      .label
        | 階層
      .content
        | 26442F
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
      eventId: 0,
      eventTimer: 99,
    };
  },
  store,
  mounted(){
    this.eventId = setInterval(this.updateEventTimer, 1000);
  },
  methods: {
    updateEventTimer(){
      const next_date = new Date(this.$store.state.event.next_event_at * 1000);
      const now = new Date();
      this.eventTimer = Math.max(Math.ceil((next_date - now) / 1000), 0);
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.header{
  height: 60px;
  width: 824px;
  top: $space;
  left: $space;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  .header_content{
    .label{
      width: 100%;
      height: 40%;
      font-size: 14px;
      &::after{
        content: "：";
      }
    }
    .content{
      width: 100%;
      height: 60%;
      font-size: 18px;
      padding-right: $space;
      text-align: right;
    }
  }
  .clock{
    width: 25%;
  }
  .next_event_time{
    width: 20%;
  }
  .dungeon_name{
    width: 20%;
  }
  .dungeon_depth{
    width: 15%;
  }
}
</style>
