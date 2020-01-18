<template lang="pug">
  #app
    Field
    Header
    RightMenu
    Status
    Chat
    Log
    AccountWindow(v-if="$store.state.ui.window.account")
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
import AccountWindow from './AccountWindow'

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
    AccountWindow,
  },
  mounted(){
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
</style>
