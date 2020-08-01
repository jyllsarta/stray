<template lang="pug">
  .cards(:class="rightSide ? 'right' : 'left'")
    transition-group(:name="rightSide ? 'right-show-in' : 'show-in'")
      Card(
        v-for="card in cards",
        :id="card.id",
        :name="card.name",
        :power="card.power",
        :tech="card.tech",
        :rightSide="rightSide"
        :key="card.id",
        @onClick="$emit('onClick', card.id)"
        :disabled="globalDisabled"
      )
</template>

<script lang="ts">
import Card from "./Card.vue";


export default {
  components: {
    Card
  },
  props: {
    cards: Array,
    rightSide: Boolean,
    globalDisabled: Boolean,
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";

.hands{
  display: flex;
  flex-direction: column;
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
