<template lang="pug">
  .right_menu.window.floating_window
    ._back(@click="setConfirmStatus(false)" v-if="showEndingConfirm")
    .items
      .category
        .japanese
          | 育成
        .english
          | Build
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', '手動で完全回復します。')",
        @click="resurrect"
      )
        img.icon(src="/images/icons/right_menu/heal.gif")
        .text
          | 回復
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', '装備メニューを表示します。')",
        @click="$store.commit('window/updateWindowShowState', {windowName: 'equip', state: true})"
      )
        img.icon(src="/images/icons/right_menu/equip.gif")
        .text
          | 装備
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', '能力解放メニューを表示します。')",
        @click="$store.commit('window/updateWindowShowState', {windowName: 'relic', state: true})"
      )
        img.icon(src="/images/icons/right_menu/relic.gif")
        .text
          | 能力解放
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', '神秘の鍋メニューを表示します。')",
        @click="$store.commit('window/updateWindowShowState', {windowName: 'gacha', state: true})"
      )
        img.icon(src="/images/icons/right_menu/gacha.gif")
        .text
          | 神秘の鍋
      .category
        .japanese
          | 冒険
        .english
          | Explore
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', 'ダンジョン切り替えメニューを表示します。')",
        @click="$store.commit('window/updateWindowShowState', {windowName: 'switch_dungeon', state: true})"
      )
        img.icon(src="/images/icons/right_menu/dungeon.gif")
        .text
          | ダンジョン
          | 切り替え
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', '戦闘メニューを表示します。')",
        @click="$store.commit('window/updateWindowShowState', {windowName: 'quest', state: true})"
      )
        img.icon(src="/images/icons/right_menu/quest.gif")
        .text
          | クエスト
      .category
        .japanese
          | 記録
        .english
          | Memorial
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', '実績メニューを表示します。')",
        @click="$store.commit('window/updateWindowShowState', {windowName: 'achievement', state: true})"
      )
        img.icon(src="/images/icons/right_menu/achievement.gif")
        .text
          | {{achievementText}}
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', '冒険のあゆみを表示します。')",
        @click="$store.commit('window/updateWindowShowState', {windowName: 'profile', state: true})"
      )
        img.icon(src="/images/icons/right_menu/profile.gif")
        .text
          | 冒険のあゆみ
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', '引き継ぎ関連のメニューを表示します。')",
        @click="$store.commit('window/updateWindowShowState', {windowName: 'account', state: true})"
      )
        img.icon(src="/images/icons/right_menu/register.gif")
        .text
          | 引き継ぎ設定
      .item.clickable(
        @mouseover="$store.commit('guide/updateGuide', 'エンディングを表示します。')",
        @click="proceedEnding"
        v-if="wonLastBoss"
      )
        img.icon(src="/images/icons/right_menu/ending.gif")
        .text
          | {{endingText}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      showEndingConfirm: false,
    };
  },
  store,
  mounted(){
  },
  computed: {
    achievementText(){
      let text = "実績";
      const receivableAchievementCount = this.$store.getters["achievement/receivableAchievementCount"];
      if(receivableAchievementCount > 0){
        text += ` (${receivableAchievementCount})`
      }
      return text;
    },
    endingText(){
      return this.showEndingConfirm ? "みる！" : "エンディング";
    },
    wonLastBoss(){
      return this.$store.state.user.status.won_last_boss;
    }
  },
  methods: {
    setConfirmStatus(status){
      this.showEndingConfirm = status;
    },
    proceedEnding(){
      if(this.showEndingConfirm){
        this.setConfirmStatus(false);
        this.$store.commit('window/updateWindowShowState', {windowName: "ending", state: true})
      }
      else{
        this.setConfirmStatus(true);
      }
    },
    resurrect(){
      if(this.$store.getters['event/isDequeueMode']){
        console.log("イベント再生中なので回復はしません");
        return;
      }

      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/resurrect`;
      ax.post(path)
        .then((results) => {
          console.log(results);
          this.$store.commit("user/resurrect");
          this.$store.commit("event/addEventLog", {message: "ご主人パワーで完全回復した！"});
          this.$store.commit("event_illust/showEventIllust", "resurrect_complete");
          this.$store.dispatch("achievement/fetchAchievements");
          this.$store.dispatch("achievement/fetchAchievementCache");
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
.right_menu{
  width: 200px - $space * 3;
  top: $space;
  right: $space;
  font-size: $font-size-normal;
  ._back{
    position: absolute;
    // 画面横幅のなにもない領域 - 20px まで当たり判定を持つ
    right: calc((#{$window-width} - 100vw + 20px)/2);
    top: -100px;
    width: 100vw;
    height: 100vh;
  }
  .items{
    display: flex;
    flex-direction: column;
  }

  .category{
    line-height: 100%;
    margin-top: $thin_space;
    margin-bottom: $thin_space;

    .japanese {
      display: inline-block;
      font-size: $font-size-mini;
      padding-left: $thin_space;
      padding-right: $thin_space;
    }
    .english {
      display: inline-block;
      font-size: $font-size-mini - 4px;
      color: $accent-color;
      font-style: italic;
    }
    border-bottom: 1px solid $gray3;
  }

  .item{
    .text{
      margin-left: $space;
      white-space: pre;
    }
    width: 100%;
    height: 40px;
    margin-top: $thin_space / 2;
    margin-bottom: $thin_space / 2;
    line-height: 100%;
    padding-left: $space;
    display: flex;
    align-items: center;
  }
}
</style>
