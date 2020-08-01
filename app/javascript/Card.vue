<template lang="pug">
.hand(@click="onClick" :class="[rightSide ? 'right_side' : 'left_side', disabled ? 'disabled' : '']")
  .name
    | {{name}}
  .value
    .power.value
      | {{power}}
    .sep
      | /
    .tech.value
      | {{tech}}
</template>

<script lang="ts">
export default {
  props: {
      id: Number,
      name: String,
      power: Number,
      tech: Number,
      rightSide: Boolean,
      disabled: Boolean,
  },
  methods: {
    onClick(){
      this.$emit('onClick', this.id);
    }
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
  .name{
    line-height: 100%;
  }
  .value {
    display: flex;
    width: 80%;
    line-height: 100%;
    justify-content: center;
    .sep {
      display: inline-block;
      width: 1.5em;
      text-align: center;
    }
    .value {
      display: inline-block;
      width: 2em;
      text-align: right;
    }
  }
  &:hover {
    filter: brightness(130%);
    transform: scale(1.1);
    border-top: 1px solid $gray1;
    border-bottom: 1px solid $gray1;
  }
}
.disabled {
  opacity: 0.5;
  pointer-events: none;
  animation: darken 0.2s;
}
.left_side{
  background: linear-gradient(80deg, transparent 0%, $gray3-opacity 5%, $gray3-opacity 95%, transparent 100%);
}
.right_side{
  background: linear-gradient(100deg, transparent 0%, $gray3-opacity 5%, $gray3-opacity 95%, transparent 100%);
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
