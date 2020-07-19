<template lang="pug">
.hand(@click="onClick")
  .name
    | {{name}}
  .value(:class="rightSide ? 'right_side' : ''")
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
  background: linear-gradient(80deg, transparent 0%, $gray3-opacity 5%, $gray3-opacity 95%, transparent 100%);
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
  .right_side{
  }
  &:hover {
    filter: brightness(130%);
    transform: scale(1.1);
  }
}
</style>
