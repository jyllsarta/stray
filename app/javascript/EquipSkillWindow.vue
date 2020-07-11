<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: false})")
        .title
          | スキル選択
      .description
        | スキルのつけ外しをします。
      .body
        .all_skills
        .selected_skills
        .detail


</template>

<script lang="ts">
  import Constants from "./packs/constants.ts";
  import store from './packs/store.ts'
  import axios from 'axios'
  import ax from "./packs/axios_default_setting.ts";
  import SkillList from "./SkillList.vue";
  import CardList from "./CardList.vue";
  import Card from "./packs/quest/card";

  export default {
      components: {
        SkillList,
      },
      data: function () {
          return {

          };
      },
      store,
  }
</script>

<style lang="scss" scoped>
  @import "stylesheets/global_setting";

  *{
    //outline: 1px solid #79f850;
  }

  .description{
    padding: $space;
    white-space: pre-wrap;
    border-bottom: 1px solid $gray3;
  }

</style>
