<template lang="pug">
  .current_clock
    .label
      | 時刻
    .content
      | {{month}}月{{date}}日 {{hours}}:{{minutes}}:{{seconds}}
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
      tickHandler: 0,
    };
  },
  mounted() {
    this.tickHandler = setInterval(this.tick, 1000);
    this.tick();
  },
  beforeDestroy(){
    clearInterval(this.tickHandler);
  },
  store,
  computed: {
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

</style>
