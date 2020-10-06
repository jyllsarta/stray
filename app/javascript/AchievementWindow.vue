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
          .achievement.selectable.hoverable(
            v-for="achievement in achievements",
            @mouseover="$store.commit('guide/updateGuide', achievement.description)",
          )
            .icon.item
              img(src="/images/icons/achievements/treasure.gif")
            .title.item
              | {{achievement.title}}
            .progress.item
              .current
                | 123123123
              .sep
                | /
              .target
                | {{achievement.progress}}
            .reward_icon.item
              img(src="/images/ui/star.png")
            .amount.item
              | x1
            .receive.item
              | 達成
        .details
          .summary
            | 実績達成数とか
          .detail
            | 詳細エリアだよ

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
      achievements(){
        return Object.values(this.$store.state.masterdata.achievement_steps);
      }
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
    display: flex;

    .achievements{
      display: flex;
      flex-direction: column;
      height: 440px;
      overflow-y: scroll;
      width: 70%;
      .achievement{
        margin: $thin_space;
        width: 100%;
        height: 30px;
        display: flex;
        flex-direction: row;
        align-items: center;
        .item{
          margin-left: $thin_space;
          margin-right: $thin_space;
        }
        .icon{
          width: 24px;
          height: 24px;
        }
        .title{
          flex-grow: 1;
          font-size: 18px; // ここも妙に通常サイズだと小さく見えるので特異なサイズにする...
        }
        .progress{
          .current, .target{
            display: inline-block;
            min-width: 3rem;
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
          margin-right: 20px;
        }
      }
    }
    .details{
      width: 30%;
    }
  }
</style>
