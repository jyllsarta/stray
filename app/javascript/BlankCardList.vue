<template lang="pug">
  .cards(:class="rightSide ? 'right' : 'left'")
    BlankCard(
      v-for="count in new Array(maxItemCount).fill(1).map((_, i) => i)",
      :key="id + count",
      :rightSide="rightSide",
    )

</template>

<script lang="ts">
import BlankCard from "./BlankCard.vue";

export default {
  components: {
    BlankCard
  },
  data() {
    return {
      id: 0,
    }
  },
  props: {
    rightSide: Boolean,
    maxItemCount: Number,
  },
  mounted() {
    this.id = Math.floor(Math.random() * 10000000);
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";

.hands{
  display: flex;
  flex-direction: column;
  pointer-events: none;
}

.left{
  .hand{
    @for $i from 1 through 8 {
      &:nth-child(#{$i}){
        margin-left: $i * 4px;
        margin-right: 32px - $i * 4px;
      }
    }
  }
}

.right{
  .hand{
    @for $i from 1 through 8 {
      &:nth-child(#{$i}){
        margin-left: 32px - $i * 4px;
      }
    }
  }
}

.show-in-enter-active {
  transition: all .2s;
}
.show-in-leave-active {
  transition: all .2s;
}
.show-in-enter{
  position: absolute;
  pointer-events: none;
  transform: translateX(-30px);
  opacity: 0;
}
.show-in-leave-to{
  position: absolute;
  pointer-events: none;
  transform: translateX(-30px);
  opacity: 0;
}

.right-show-in-enter-active {
  transition: all .2s;
}
.right-show-in-leave-active {
  transition: all .2s;
}
.right-show-in-enter{
  position: absolute;
  pointer-events: none;
  transform: translateX(30px);
  opacity: 0;
}
.right-show-in-leave-to{
  position: absolute;
  pointer-events: none;
  transform: translateX(30px);
  opacity: 0;
}

</style>
