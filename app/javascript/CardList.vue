<template lang="pug">
  .cards(:class="rightSide ? 'right' : 'left'")
    Card(
      v-for="card in cards",
      :id="card.id",
      :name="card.name",
      :power="card.power",
      :tech="card.tech",
      :rightSide="rightSide"
      :key="card.id",
      @onClick="$emit('onClick', card.id)"
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
        margin-left: $i * 6px;
        margin-right: 48px - $i * 6px;
      }
    }
  }
}

.right{
  .hand{
    @for $i from 1 through 8 {
      &:nth-child(#{$i}){
        margin-left: 48px - $i * 6px;
      }
    }
  }
}

</style>
