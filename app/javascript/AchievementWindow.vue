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
            @click="selectAchievement(achievement.id)",
            :class="achievement.id === selectingAchievementId ? 'selected' : 'not_selected'"
          )
            .height_block
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
              | x{{achievement.rewards[0] ? achievement.rewards[0].amount : 0}}
            .receive.item
              | 達成
        .details
          .summary
            .label
              | トータル実績達成率：
            .value
              | 75%
          .detail
            .descri
              | 選択中の実績：
            .titles
              .icon
                img(src="/images/icons/achievements/treasure.gif")
              .title
               | {{selectingAchievement.title}}
            .description
              | {{selectingAchievement.description}}
            .current.key_value
              .key
                | 現在値：
              .value
                | 876876876
            .taeget.key_value
              .key
                | 目標値：
              .value
                | {{selectingAchievement.progress}}
            .reward.key_value
              .key
                | 報酬：
              .value
                .icon
                  img(src="/images/ui/star.png")
                .amount
                  | x{{selectingAchievement.rewards[0] ? selectingAchievement.rewards[0].amount : 0}}
            .reward_button_area
              .reward_button.clickable
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
        selectingAchievementId: -1,
        playerAchievements: [],
        playerAchievementSteps: [],
      };
    },
    mounted(){
      this.fetchPlayerAchievements();
    },
    store,
    computed: {
      achievements(){
        return Object.values(this.$store.state.masterdata.achievement_steps);
      },
      selectingAchievement(){
        const achievement = this.$store.state.masterdata.achievement_steps[this.selectingAchievementId];
        if(achievement){
          return achievement;
        }
        return {
          title: "-",
          description: "",
          progress: "-",
          rewards: [
            {
              amount: "-"
            }
          ]
        }
      },
    },
    methods: {
      selectAchievement(id){
        this.selectingAchievementId = id;
      },
      fetchPlayerAchievements(){
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/achievements.json`;
        ax.get(path)
          .then((results) => {
            console.log(results);
            this.playerAchievements = results.data.achievements;
            this.playerAchievementSteps = results.data.achievement_steps;
          })
          .catch((error) => {
            console.warn(error.response);
            console.warn("NG");
          });
      },
    }
  }
</script>

<style lang="scss" scoped>
  @import "stylesheets/global_setting";

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
      width: 75%;
      .achievement{
        margin: $thin_space / 2;
        width: calc(100% - 8px);
        display: flex;
        flex-direction: row;
        align-items: center;
        .height_block{
          height: 40px; // achievement 全体の高さをこいつで決めている
        }
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
          width: 20px;
          height: 20px;
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
      width: 25%;
      padding: $space;
      .summary{
        border-bottom: 1px solid $gray3;
        .label{
        }
        .value{
          width: 100%;
          font-size: $font-size-large;
          text-align: right;
        }
      }
      .detail{
        .titles{
          height: 50px;
          display: flex;
          align-items: center;
          .icon{
            display: inline-block;
            width: 24px;
            height: 24px;
          }
          .title{
            display: inline-block;
            padding-left: $space;
            font-size: 18px;
            line-height: 110%;
          }
        }
        .description{
          height: 100px;
        }
        .key_value{
          padding-top: $space;
          height: 40px;
          .key{
            display: inline-block;
            width: 30%;
            margin-left: 10%;
            text-align: right;
          }
          .value{
            display: inline-block;
            padding-left: $thin_space;
            width: 60%;
          }
        }
        .reward{
          .icon{
            display: inline-block;
            width: 24px;
            height: 24px;
            img{
              width: 100%;
              height: 100%;
            }
          }
          .amount{
            display: inline-block;
          }
        }
        .reward_button_area{
          width: 100%;
          height: 80px;
          display: flex;
          justify-content: center;
          align-items: center;
          .reward_button{
            @include centering($height: 40px);
            width: 100px;
          }
        }
      }
    }
  }
</style>
