<template lang="pug">
  #app
    Field
    Header
    RightMenu
    Status
    Chat
    Log
    Api
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Api from './Api'
import Field from './Field'
import Header from './Header'
import RightMenu from './RightMenu'
import Log from './Log'
import Status from './Status'
import Chat from './Chat'

export default {
  data: function () {
    return {};
  },
  store,
  components: {
    Api,
    Field,
    Header,
    RightMenu,
    Log,
    Status,
    Chat,
  },
  mounted(){
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
#app{
  position: relative;
  margin: 50px auto;
  // TODO: ウィンドウサイズはデバッグしやすいように小さめにしているけど、将来的に再検討する
  width: $window-width;
  height: $window-height;
  background-color: $background;
  color: $white;
  font-family: "M PLUS Rounded 1c", sans-serif;
  font-size: 16px;
  .window{
    position: absolute;
    border: 1px solid $gray3;
    border-radius: $radius;
    padding: $thin_space;
  }
}
</style>
