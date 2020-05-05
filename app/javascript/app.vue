<template lang="pug">
  #app
    Guide
    .game
      Field(ref="field")
      Header
      RightMenu
      Status
      Log
      EventIllust
      TransitionFrame(v-if="$store.state.window.transition_frame")
      transition(name="open_window")
        AccountWindow(v-if="$store.state.window.account")
      transition(name="open_window")
        EquipWindow(v-if="$store.state.window.equip")
      transition(name="open_window")
        EquipDetailWindow(v-if="$store.state.window.equip_detail")
      transition(name="open_window")
        SwitchDungeonWindow(v-if="$store.state.window.switch_dungeon" :root-ref="$refs")
      Api(ref="api")
      Timer
      EventWatcher(:root-ref="$refs")
      LoadingFrame(v-if="$store.state.window.loading_frame")
    MessageForm
</template>

<script lang="ts">
import store from './packs/store.ts'
import Api from './Api'
import Guide from './Guide'
import Field from './Field'
import Header from './Header'
import RightMenu from './RightMenu'
import Log from './Log'
import Status from './Status'
import EventIllust from './EventIllust'
import AccountWindow from './AccountWindow'
import EquipWindow from './EquipWindow'
import EquipDetailWindow from './EquipDetailWindow'
import SwitchDungeonWindow from './SwitchDungeonWindow'
import Timer from './Timer'
import MessageForm from './MessageForm'
import EventWatcher from "./EventWatcher";
import TransitionFrame from "./TransitionFrame.vue";
import LoadingFrame from "./LoadingFrame.vue";

export default {
  store,
  components: {
    Api,
    Guide,
    Field,
    Header,
    RightMenu,
    Log,
    Status,
    EventIllust,
    AccountWindow,
    EquipWindow,
    EquipDetailWindow,
    SwitchDungeonWindow,
    TransitionFrame,
    LoadingFrame,
    Timer,
    EventWatcher,
    MessageForm,
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
</style>
