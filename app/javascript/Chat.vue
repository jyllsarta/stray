<template lang="pug">
  .chat.window
    img.spica(src="images/ui/chat_spica.png")
    .chat_window
      .spica.bubble
        | このへんは特になんにもないね
      .tirol.bubble
        | 霊力の流れを感じる...
    img.tirol(src="images/ui/chat_tirol.png")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {};
  },
  store,
  mounted(){
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.chat{
  height: 100px;
  width: $window-width - 500px - $space;
  bottom: $space;
  left: 300px + $space * 2;
  padding: 0;
  display: flex;
  flex-direction: row;
  align-content: space-between;
  img{
    height: 100%;
  }
  .chat_window{
    padding: $thin_space;
    flex: 1;
    display: flex;
    flex-direction: column;
    // TODO: background-colorが発言のあるとこまでになるような工夫をしたい
    .bubble{
      padding: $thin_space;
      background-color: $gray3;
      margin-bottom: $thin_space;
      border-radius: $radius;
    }
    .spica{
      text-align: left;
    }
    .tirol{
      text-align: right;
    }
  }
  .tirol{

  }
}
</style>
