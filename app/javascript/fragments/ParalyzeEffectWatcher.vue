<template lang="pug">
</template>

<script lang="ts">
import Constants from "../packs/constants.ts";
import store from '../packs/store.ts'

export default {
  props: {
    battle: Object,
  },
  watch: {
    "battle.shouldShowParalyzeEffect": {
      handler: function(newVal, oldVal){
        if(newVal){
          this.$store.commit("battle/showFragment", "paralyze_effect")
          this.battle.shouldShowParalyzeEffect = false;
        }
      },
    },
  }
}
</script>

<style lang="scss" scoped>

</style>