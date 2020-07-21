<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: false})")
        .title
          | 強敵戦・準備
      .description
        | 強敵と戦います。
      .body
        .characters
          img.tirol(src="/images/battle/tirol/normal.png")
          img.spica(src="/images/battle/spica/normal.png")
        .enemy_character
          img.enemy(src="/images/battle/enemy.png")
        .enemy_reward
          .descri
            | 撃破報酬：
          img.icon(:src="`/images/ui/${currentEnemyRewardType}.png`")
          .count
            | × {{ currentEnemyReward.amount }}
        CardList.player_deck(
          :cards="currentPlayerCards"
          :right-side="false"
        )
        CardList.enemy_deck(
          :cards="enemyDeck"
          :right-side="true"
        )
        .enemy_list.scrollable
          .enemy.clickable(v-for="enemy in enemyList" @click="selectEnemy(enemy.id)")
            .name
              | {{enemy.name}}
            .rank
              | {{enemy.rank}}
        .status_area
          .status
            .player
              | {{averageItemRank}}
            .label
              | 平均IR
            .enemy
              | {{currentEnemy.rank}}
          .status
            .player
              | 1
            .label
              | 力威力
            .enemy
              | {{currentEnemy.power}}
          .status
            .player
              | 1
            .label
              | 技威力
            .enemy
              | {{currentEnemy.tech}}
          .status
            .player
              | 1
            .label
              | SP威力
            .enemy
              | {{currentEnemy.special}}
          .status
            .player
              | 5
            .label
              | HP
            .enemy
              | {{currentEnemy.hp}}
        .player_rank
          .desc
            | 平均装備ランク：
          .rank
            | {{averageItemRank}}
        .open_skill_window.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: true})")
          | スキル選択
        .switch_deck_type
          .class_cards(@click="showsClassCards = true", :class="showsClassCards ? 'active' : ''")
            | クラスカード
          .equip_cards(@click="showsClassCards = false", :class="showsClassCards ? '' : 'active'")
            | 装備
        .player_skill_list
          SkillList(:isPlayer="true", :skills="$store.state.skill.skills.filter((x)=>x.is_equipped)")
        .enemy_skill_list
          SkillList(:isPlayer="false", :skills="currentEnemy.skills")
        .battle_start.clickable(@click="startBattle")
          | 戦闘開始
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
          CardList,
      },
      data: function () {
          return {
              selectingEnemyId: 1,
              showsClassCards: false,
              enemyList: [],
              classCardsResponse: [],
              itemCardsResponse: [],
              averageItemRank: 0,
          };
      },
      store,
      mounted(){
          this.fetchEnemyList();
          this.fetchPlayerDeck();
          this.fetchPlayerSkills();
      },
      computed: {
          currentEnemy(){
              return this.enemyList.find((x)=>x.id===this.selectingEnemyId) || {};
          },
          currentEnemyReward(){
              if(!this.currentEnemy?.rewards){
                  return {};
              }
              return this.currentEnemy?.rewards[0];
          },
          currentEnemyRewardType(){
              return this.currentEnemyReward?.giftable_type?.toLowerCase() || 'coin';
          },
          enemyDeck(){
              return this.currentEnemy?.cards?.map((x)=>new Card(x.id, x.name, x.power, x.tech))
          },
          currentPlayerCards(){
              const cards = this.showsClassCards ? this.classCardsResponse : this.itemCardsResponse;
              return cards?.map((x)=>new Card(x.id, x.name, x.power, x.tech));
          }
      },
      methods: {
          selectEnemy(id){
              this.selectingEnemyId = id;
          },

          fetchEnemyList(){
              const path = `/enemies.json`;
              ax.get(path)
                  .then((results) => {
                      console.log(results);
                      console.log("OK");
                      this.enemyList = results.data.enemies;
                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
          },
          fetchPlayerSkills(){
              const path = `/skills.json`;
              ax.get(path)
                  .then((results) => {
                      console.log(results);
                      console.log("OK");
                      this.$store.commit("skill/setPlayerSkills", results.data.skills);
                      this.selectingSkillIds = this.$store.state.skill.skills.filter((x)=>x.is_equipped).map((x)=>x.id);
                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
          },
          fetchPlayerDeck(){
              const user_id = localStorage.user_id;
              const path = `/users/${user_id}/deck.json`;
              ax.get(path)
                  .then((results) => {
                      console.log(results);
                      console.log("OK");
                      this.classCardsResponse = results.data.class_cards;
                      this.itemCardsResponse = results.data.item_cards;
                      this.averageItemRank = results.data.average_item_rank;
                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
          },

          startBattle(){
              this.$store.commit("battle/setEnemyId", this.selectingEnemyId);
              this.$store.commit("window/updateWindowShowState", {windowName: "battle", state: true})
          }
      },
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

  .body {
    .characters{
      position: absolute;
      bottom: $space + 70px;
      left: $space;
      .spica{
        position: absolute;
        bottom: 0;
        left: 0;
        width: 256px;
        height: 256px;
      }
      .tirol{
        position: absolute;
        bottom: 0;
        left: -50px;
        width: 256px;
        height: 256px;
      }
    }

    .enemy_character{
      position: absolute;
      bottom: $space + 70px;
      right: $space;
      .enemy{
        width: 256px;
        height: 256px;
      }
    }

    .enemy_reward{
      position: absolute;
      bottom: $space + 70px;
      right: $space;
      width: 200px;
      height: 40px;
      background-color: $background_with_opacity;
      border-radius: $radius;
      padding: $thin_space;
      .descri, .icon, .count{
        display: inline-block;
      }
      .icon{
        width: $font-size-normal;
        height: $font-size-normal;
      }
    }

    .player_deck{
      position: absolute;
      left: 205px;
      top: 100px;
      width: 198px;
      height: 330px;
    }

    .enemy_deck{
      position: absolute;
      right: 205px;
      top: 100px;
      width: 198px;
      height: 330px;
    }

    .enemy_list{
      position: absolute;
      right: $space;
      top: 100px;
      width: 200px;
      height: 200px;
      .enemy{
        @include centering($height: 30px);
        margin: 2px;
        width: calc(100% - 15px);
        .name, .rank{
          display: inline-block;
          text-align: left;
          width: calc(100% - 2.5em);
        }
        .rank{
          width: 2em;
        }
      }
    }

    .status_area{
      position: absolute;
      left: calc((100% - 180px) / 2);
      top: 200px;
      width: 180px;
      height: 100px;
      .status{
        padding: $thin_space;
        width: 100%;
        display: flex;
        text-align: center;
        align-items: baseline;
        .player, .enemy{
          width: 35%;
          font-size: $font-size-large;
        }
        .label{
          width: 30%;
        }
      }
    }

    .player_rank{
      position: absolute;
      left: $space;
      top: 100px;
      width: 140px;
      height: 60px;
      .rank{
        font-size: $font-size-large;
        width: 100%;
        text-align: right;
      }
    }

    .open_skill_window{
      position: absolute;
      left: 230px;
      bottom: 75px;
      width: 170px;
      border-radius: $radius;
      @include centering($height: 30px);
    }

    .switch_deck_type{
      position: absolute;
      left: $space;
      top: 155px;
      width: 140px;
      height: 56px;
      .class_cards, .equip_cards{
        border-radius: $radius;
        width: 140px;
        height: 28px;
        padding: 2px;
        text-align: center;
        border: 1px solid $gray3;
      }
      .active{
        background-color: $gray3;
      }
    }

    .player_skill_list{
      position: absolute;
      bottom: $thin_space;
      left: $thin_space;
    }
    .enemy_skill_list{
      position: absolute;
      bottom: $thin_space;
      right: $thin_space;
    }

    .battle_start{
      position: absolute;
      bottom: 80px;
      left: calc((100% - 150px) / 2);
      width: 150px;
      @include centering($height: 50px);
    }
  }
</style>
