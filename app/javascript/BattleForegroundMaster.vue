<template lang="pug">
  .foreground_fields(:class="turnInProgress ? 'zoomed' : 'normal'")
    BattleForeground(v-if="fieldEffectStateId == null")
    BattleForegroundLeaf(v-if="fieldEffectStateId == 102")
    BattleForegroundFire(v-if="fieldEffectStateId == 103")
    BattleForegroundThunder(v-if="fieldEffectStateId == 104")
    BattleForegroundWind(v-if="fieldEffectStateId == 105")
    BattleForegroundDark(v-if="fieldEffectStateId == 106")
    BattleForegroundMagic(v-if="fieldEffectStateId == 107")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import BattleForeground from "./BattleForeground.vue";
import BattleForegroundLeaf from "./BattleForegroundLeaf.vue";
import BattleForegroundFire from "./BattleForegroundFire.vue";
import BattleForegroundThunder from "./BattleForegroundThunder.vue";
import BattleForegroundWind from "./BattleForegroundWind.vue";
import BattleForegroundDark from "./BattleForegroundDark.vue";
import BattleForegroundMagic from "./BattleForegroundMagic.vue";

export default {
  components: {
    BattleForeground,
    BattleForegroundLeaf,
    BattleForegroundFire,
    BattleForegroundThunder,
    BattleForegroundWind,
    BattleForegroundDark,
    BattleForegroundMagic,
  },
  props: {
    turnInProgress: Boolean,
    fieldEffectState: Object,
  },
  data: function () {
    return {
    };
  },
  store,
  mounted(){
  },
  computed: {
    fieldEffectStateId(){
      return this.fieldEffectState?.stateMaster?.id;
    }
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.foreground_fields{
  position: relative;
  width: 100%;
  height: 100%;
}

.zoomed{
  transition: transform 0.6s;
  transform: scale(1.3);
}
.normal{
  transition: transform 0.6s;
  transform: scale(1);
}
</style>
