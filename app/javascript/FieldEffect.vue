<template lang="pug">
.field_effect
  .upper(v-if="getState.stateMaster.icon")
    img.icon(
      :src="`/images/icons/states/${getState.stateMaster.icon}`"
      :class="getState.isFlashing ? 'flashing' : ''",
      )
    .name
      | {{getState.stateMaster.title}}
  .downer
    .description
      | {{getState.stateMaster.description}}
</template>

<script lang="ts">
export default {
  props: {
    fieldEffectState: Object,
  },
  computed: {
    getState(){
      if(!this.fieldEffectState){
        return {
          stateMaster: {}
        };
      }
      return this.fieldEffectState;
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
.field_effect{
  .upper{
    display: flex;
    align-items: center;
    height: 24px;
    border-bottom: 1px solid $gray3;
    font-size: $font-size-large;
  }
  .downer{
    width: 300px;
    font-size: $font-size-mini;
    line-height: 120%;
  }
}


.flashing{
  animation: anim 0.3s;
}

@keyframes anim {
  0% {
    opacity: 0.4;
    transform: scale(3);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}
</style>
