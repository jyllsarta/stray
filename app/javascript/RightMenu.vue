<template lang="pug">
  .right_menu.window.floating_window
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
      @mouseover="$store.commit('guide/updateGuide', 'ダンジョン切り替えメニューを表示します。')",
      @click="$store.commit('window/updateWindowShowState', {windowName: 'switch_dungeon', state: true})"
    )
      img.icon(src="/images/icons/right_menu/dungeon.gif")
      .text
        | ダンジョン
        | 切り替え
    .item.clickable(
      @mouseover="$store.commit('guide/updateGuide', '能力解放メニューを表示します。')",
      @click="$store.commit('window/updateWindowShowState', {windowName: 'relic', state: true})"
    )
      img.icon(src="/images/icons/right_menu/relic.gif")
      .text
        | 能力解放
    .item.clickable(
      @mouseover="$store.commit('guide/updateGuide', '戦闘メニューを表示します。')",
      @click="$store.commit('window/updateWindowShowState', {windowName: 'quest', state: true})"
    )
      img.icon(src="/images/icons/right_menu/quest.gif")
      .text
        | クエスト
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
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {};
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
    }
  },
  methods: {
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
          this.$store.commit("event_illust/showEventIllust", "resurrect");
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
  display: flex;
  flex-direction: column;
  font-size: $font-size-normal;
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
