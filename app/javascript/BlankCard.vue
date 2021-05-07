<template lang="pug">
.hand(:class="[rightSide ? 'right_side' : 'left_side']")
</template>

<script lang="ts">
export default {
  props: {
    rightSide: Boolean,
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
.hand {
  padding: 4px 4px 4px 10px;
  height: 38px;
  width: 165px;
  margin-bottom: 2px;
  border: 1px solid $gray3;
  background-image: linear-gradient(to bottom, transparent 0%, transparent 70%, $gray3-opacity 100%);
}
.left_side{
  transform: skew(10deg);
}
.right_side{
  transform: skew(-10deg);
}

@keyframes darken {
  0% {
    opacity: 1;
  }
  100%{
    opacity: 0.5;
  }
}
</style>
