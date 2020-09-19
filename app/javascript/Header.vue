<template lang="pug">
  .header.window
    .clock.header_content
      .label
        | 時刻
      .content
        | {{month}}月{{date}}日 {{hours}}:{{minutes}}:{{seconds}}
    .next_event_time.header_content
      .label
        | 次回イベントまで
      .content
        | {{$store.state.timer.next_event}}秒
    .dungeon_name.header_content
      .label
        | 現在地
      .content
        | {{$store.getters['masterdata/getCurrentDungeon'].name}}
    .dungeon_depth.header_content
      .label
        | 階層
      .content.floor
        .current(:class="floorColorClass")
          | {{$store.state.user.status.current_dungeon_depth}}
        .sep
          | /
        .depth
          | {{$store.getters['masterdata/getCurrentDungeon'].depth}}
        .sep
          | F
    .resources
      .line
        .coin_icon
        .value
          | {{$store.state.user.status.coin}}
      .line
        .star_icon
        .value
          | {{$store.state.user.status.star}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
      month: "0",
      date: "0",
      hours: "0",
      minutes: "0",
      seconds: "0",
    };
  },
  mounted() {
    setInterval(this.tick, 1000);
  },
  store,
  computed: {
    floorColorClass(){
      if(this.$store.getters['user/isNearBossFloor']){
        return "boss_floor"
      }
      if(this.$store.getters['user/isOverFloor']){
        return "over_floor";
      }
      return "";
    }
  },
  methods: {
    tick(){
      const now = new Date();
      this.month = now.getMonth() + 1;
      this.date = now.getDate();
      this.hours = this.format(now.getHours());
      this.minutes = this.format(now.getMinutes());
      this.seconds = this.format(now.getSeconds());
    },
    format(time){
      return ("00" + time).slice(-2)
    }
  }
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
      padding-top: $space;
      text-align: right;
      line-height: 100%;
    }
  }
  .clock{
    width: 22%;
  }
  .next_event_time{
    width: 20%;
  }
  .dungeon_name{
    width: 15%;
  }
  .dungeon_depth{
    width: 20%;
  }
  .resources{
    width: 15%;
  }
  .floor{
    .current{
      display: inline-block;
    }
    .sep{
      padding: 0 $thin_space 0 $thin_space;
      display: inline-block;
      font-size: $font-size-mini;
    }
    .depth{
      display: inline-block;
    }
    .over_floor{
      color: $yellow;
    }
    .boss_floor{
      color: $plus;
    }
  }
  .resources{
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding-top: $thin_space;
    padding-bottom: $thin_space;
    .line{
      display: flex;
      align-items: flex-end;
      line-height: 100%;
      div{
        display: inline-block;
      }
      .coin_icon{
        width: 20px;
        height: 20px;
        display: inline-block;
        background-image: url("/images/ui/coin.png");
        background-size: cover;
      }
      .star_icon{
        width: 20px;
        height: 20px;
        display: inline-block;
        background-image: url("/images/ui/star.png");
        background-size: cover;
      }
      .value{
        text-align: right;
        width: 6rem;
      }
    }
  }
}
</style>
