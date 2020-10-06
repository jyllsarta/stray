<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'achievement', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'achievement', state: false})")
        .title
          | 実績
      .description
        | これまでに取得した実績を確認できます。報酬がある場合受け取れます。
      .body

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
    },
    data: function () {
      return {
      };
    },
    mounted(){
    },
    store,
    computed: {
    },
    methods: {
    }
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

  .body{
  }
</style>
