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
    };
  },
  mounted() {
  },
  store,
  computed: {
  },
  methods: {
    update(){
      const now = this.$store.getters["event/pseudoCurrentTime"];
      this.month = now.getMonth() + 1;
      this.date = now.getDate();
      this.hours = this.format(now.getHours());
      this.minutes = this.format(now.getMinutes());
      this.seconds = this.format(now.getSeconds());
    },
    format(time){
      return ("00" + time).slice(-2)
    }
  },
  watch: {
    "$store.state.event.eventsQueue": {
      handler: function(eventsQueue){
        if(eventsQueue.length > 0){
          this.update();
        }
      },
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
  border-bottom: 1px solid $gray3;
}
.content{
  color: $yellow;
  width: 100%;
  height: 60%;
  font-size: 18px;
  padding-top: $space;
  text-align: right;
  line-height: 100%;
}

</style>
