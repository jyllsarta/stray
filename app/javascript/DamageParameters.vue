<template lang="pug">
.parameters
  .param(@mouseover="$store.commit('guide/updateGuide', '力判定のダメージ値。')")
    img.icon(src="/images/icons/misc/power.gif")
    .value(:class="powerClass", :key="power")
      | {{ power }}
  .param(@mouseover="$store.commit('guide/updateGuide', '技判定のダメージ値。')")
    img.icon(src="/images/icons/misc/tech.gif")
    .value(:class="techClass", :key="tech")
      | {{ tech }}
  .param(@mouseover="$store.commit('guide/updateGuide', 'SP攻撃のダメージ値。')")
    img.icon(src="/images/icons/misc/special.gif")
    .value(:class="specialClass", :key="special")
      | {{ special }}
</template>

<script lang="ts">
export default {
  props: {
    power: Number,
    tech: Number,
    special: Number,
    basicPower: Number,
    basicTech: Number,
    basicSpecial: Number,
  },
  computed: {
      powerClass() {
          if (this.power > this.basicPower) {
              return "up";
          }
          return "";
      },
      techClass() {
          if (this.tech > this.basicTech) {
              return "up";
          }
          return "";
      },
      specialClass() {
          if (this.special > this.basicSpecial) {
              return "up";
          }
          return "";
      },
  }
}
</script>

<style lang="scss" scoped>
  @import "stylesheets/global_setting";
  .parameters{
    height: 16px;
    display: flex;
    .param{
      .icon, .value{
        display: inline-block;
      }
      .value{
        width: 1rem;
        animation: flash .5s cubic-bezier(.33,.81,.62,.92);
      }
      .up{
        color: $yellow;
      }
    }
  }

  @keyframes flash {
    0% {
      transform: scale(3);
      opacity: 0.4;
    }
    100% {
      transform: scale(1);
      opacity: 1;
    }
  }
</style>
