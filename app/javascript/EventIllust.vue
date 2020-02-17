<template lang="pug">
  .event_illust
    transition(name="show-in")
      img.illust(
        v-if="$store.state.ui.event_illust.showing",
        :src="`images/events/${$store.state.ui.event_illust.type}.png`"
      )
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {};
  },
  store,
  methods: {
    remove(){
      this.$store.commit("removeEventIllust");
    }
  },
  watch: {
    "$store.state.ui.event_illust.showing": {
      handler: function(newVal, oldVal){
        if(newVal === true){
          setTimeout(this.remove, Constants.eventIllustShowMilliSeconds);
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.event_illust{
  position: absolute;
  width: 60%;
  margin-left: 20%;
  margin-top: 10%;
  pointer-events: none;
  .illust{
    width: 100%;
  }

  .show-in-enter-active {
    transition: all .3s;
  }
  .show-in-leave-active {
    transition: all .3s;
  }
  .show-in-enter{
    transform: translateY(20px);
    opacity: 0;
  }
  .show-in-leave-to{
    transform: translateY(-20px);
    opacity: 0;
  }
}
</style>
