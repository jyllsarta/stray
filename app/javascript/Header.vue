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
        | {{$store.state.timer.next_event}}秒
    .dungeon_name.header_content
      .label
        | 現在地
      .content
        | {{$store.getters.getCurrentDungeon.name}}
    .dungeon_depth.header_content
      .label
        | 階層
      .content
        | {{$store.state.user.status.current_dungeon_depth}} / {{$store.getters.getCurrentDungeon.depth}}F
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
    };
  },
  store,
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.header{
  height: 60px;
  width: $window-width - 200px;
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
