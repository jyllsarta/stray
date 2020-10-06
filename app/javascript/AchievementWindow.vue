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
        .achievements
          .achievement
            .icon.item
              img(src="/images/icons/achievements/treasure.gif")
            .title.item
              | 全部一緒じゃないですかー！
            .progress.item
              .current
                | 3000
              .sep
                | /
              .target
                | 2500
            .reward_icon.item
              img(src="/images/ui/star.png")
            .amount.item
              | x1
            .receive.clickable.item
              | 達成

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
    .achievements{
      display: flex;
      flex-direction: row;
      flex-wrap: wrap;
      .achievement{
        margin: $thin_space;
        width: 70%;
        height: 30px;
        display: flex;
        flex-direction: row;
        align-items: center;
        .item{
          margin: $thin_space;
        }
        .icon{
          width: 24px;
          height: 24px;
        }
        .title{
          width: 240px;
        }
        .progress{
          .current, .target{
            display: inline-block;
            width: 5rem;
            text-align: right;
          }
          .sep{
            display: inline-block;
            width: 1rem;
            text-align: center;
          }
        }
        .reward_icon{
          width: 22px;
          height: 22px;
          img{
            width: 100%;
            height: 100%;
          }
        }
        .amount{
          width: 20px;
        }
        .receive{
          @include centering($height: 30px);
          width: 40px;
        }
      }
    }
  }
</style>
