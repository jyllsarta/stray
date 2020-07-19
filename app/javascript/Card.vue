<template lang="pug">
.hand(@click="onClick" :class="rightSide ? 'right_side' : 'left_side'")
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
  width: 150px;
  margin-bottom: 2px;
  .name{
    line-height: 100%;
  }
  .value {
    display: flex;
    width: 100%;
    line-height: 100%;
    .sep {
      display: inline-block;
      width: 1em;
      text-align: center;
    }
    .value {
      display: inline-block;
      width: 2.5em;
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
.left_side{
  background: linear-gradient(80deg, transparent 0%, $gray3-opacity 5%, $gray3-opacity 95%, transparent 100%);
}
.right_side{
  background: linear-gradient(100deg, transparent 0%, $gray3-opacity 5%, $gray3-opacity 95%, transparent 100%);
}
</style>
