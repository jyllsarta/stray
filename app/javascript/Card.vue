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
.hand {
  padding: 2px;
  .value {
    display: flex;
    width: 100%;
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
    justify-content: flex-end;
  }
  &:hover {
    filter: brightness(130%);
  }
}
</style>
