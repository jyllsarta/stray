<template lang="pug">
  .header.window.floating_window
    .clock.header_content(v-if="!$store.getters['event/isDequeueMode']")
      CurrentClock
    .clock.header_content(v-if="$store.getters['event/isDequeueMode']")
      PseudoClock
    .until_next_event.header_content(v-if="!$store.getters['event/isDequeueMode']")
      UntilNextEvent
    .rest_event_time.header_content(v-if="$store.getters['event/isDequeueMode']")
      RestEventTime
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
        .floor_label
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
import UntilNextEvent from './UntilNextEvent'
import RestEventTime from "./RestEventTime.vue";
import CurrentClock from "./CurrentClock.vue";
import PseudoClock from "./PseudoClock.vue";

export default {
  components: {
    PseudoClock,
    CurrentClock,
    RestEventTime,
    UntilNextEvent,
  },
  data: function () {
    return {
    };
  },
  mounted() {
  },
  store,
  computed: {
    floorColorClass(){
      if(this.$store.getters['user/isOverFloor']){
        return "over_floor";
      }
      return "";
    }
  },
  methods: {
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
      border-bottom: 1px solid $gray3;
    }
    .content{
      width: 100%;
      height: 60%;
      font-size: 18px;
      padding-top: $space;
      text-align: right;
      line-height: 100%;
    }
  }
  .clock{
    width: 22%;
  }
  .until_next_event{
    width: 18%;
  }
  .rest_event_time{
    width: 18%;
  }
  .dungeon_name{
    width: 18%;
  }
  .dungeon_depth{
    width: 18%;
  }
  .resources{
    width: 17%;
  }
  .floor{
    .current{
      display: inline-block;
    }
    .sep{
      padding: 0 $subtle_space 0 $subtle_space;
      display: inline-block;
      font-size: $font-size-mini;
    }
    .floor_label{
      padding-left: $subtle_space;
      display: inline-block;
      font-size: $font-size-mini;
    }
    .depth{
      display: inline-block;
    }
    .over_floor{
      color: $yellow;
    }
  }
  .resources{
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    border-left: 1px solid $gray3;
    padding-left: $space;
    padding-right: $space;
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
        width: 7rem;
      }
    }
  }
}
</style>
