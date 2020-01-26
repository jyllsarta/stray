<template lang="pug">
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
    // store のイベントタイマーを更新するためのコンポーネント
    setInterval(this.updateEventTimer, 1000);
  },
  methods: {
    updateEventTimer(){
      const next_date = new Date(this.$store.state.event.next_event_at * 1000);
      const now = new Date();
      // 実際にサーバ上でイベントが発生する時刻より Constants.nextEventDelaySeconds 秒だけ遅れさせてからリクエストを取りに行く
      const time = Math.max(Math.ceil((next_date - now) / 1000) + Constants.nextEventDelaySeconds, 0);
      this.$store.commit("updateEventTimer", {time: time});
    },
  },
}
</script>

<style lang="scss" scoped>
</style>
