<template lang="pug">
  .achievement_complete_flash
    transition(name="show-in")
      .achievement(v-if="showing")
        .body
          .title
            | {{title}}
          .descri
            | ◇◇◇ 実績を達成しました ◇◇◇
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
      showing: false,
      title: "",
      timerHandler: 0,
    };
  },
  store,
  computed: {
  },
  methods: {
    remove(){
      this.showing = false;
    }
  },
  watch: {
    "$store.state.achievement.user_completed_achievement_steps": {
      handler: function(newVal, oldVal){
        if(newVal.length !== 0){
          this.showing = true;
          this.title = this.$store.state.masterdata.achievement_steps[newVal[0]]?.title;
          clearTimeout(this.timerHandler);
          this.timerHandler = setTimeout(this.remove, 6000);
          for(let step_id of newVal){
            if(!this.$store.state.masterdata.achievement_steps[step_id]?.title){
              continue;
            }
            this.$store.commit("event/addEventLog", {message: `実績：${this.$store.state.masterdata.achievement_steps[step_id]?.title}を達成した！`});
          }
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.achievement_complete_flash{
    position: absolute;
    width: 60%;
    margin-left: 20%;
    margin-top: 45%;
    pointer-events: none;
  .achievement{
    width: 100%;
    border: 1px solid $gray3;
    border-radius: $radius;
    padding: $thin_space;
    background-color: $background_with_opacity;
    .body{
      width: 100%;
      .title, .descri{
        width: 100%;
        text-align: center;
      }
    }
  }
  .show-in-enter-active {
    transition: all .6s;
  }
  .show-in-leave-active {
    transition: all .6s;
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
