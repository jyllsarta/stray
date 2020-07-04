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
          img.tirol(src="/images/battle/tirol.png")
          img.spica(src="/images/battle/spica.png")
        .enemy_character
          img.enemy(src="/images/battle/enemy.png")
        CardList.player_deck(
          :cards="playerDeck"
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
              | 1219
            .label
              | 平均IR
            .enemy
              | 9974
          .status
            .player
              | 1
            .label
              | 力威力
            .enemy
              | 1
          .status
            .player
              | 1
            .label
              | 技威力
            .enemy
              | 1
          .status
            .player
              | 1
            .label
              | SP威力
            .enemy
              | 1
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
            | 231
        .open_magic_window
          | 魔法選択
        .switch_deck_type
          .class_cards
            | クラスカード
          .equip_cards.active
            | 装備
        .player_magic_list
          MagicList(:isPlayer="true")
        .enemy_magic_list
          MagicList(:isPlayer="false")
        .battle_start.clickable(@click="startBattle")
          | 戦闘開始
</template>

<script lang="ts">
  import Constants from "./packs/constants.ts";
  import store from './packs/store.ts'
  import axios from 'axios'
  import ax from "./packs/axios_default_setting.ts";
  import MagicList from "./MagicList.vue";
  import CardList from "./CardList.vue";
  import Card from "./packs/quest/card";

  export default {
      components: {
          MagicList,
          CardList,
      },
      data: function () {
          return {
              selectingEnemyId: 1,
              enemyList: [],
              playerDeckResponse: [],
          };
      },
      store,
      mounted(){
          this.fetchEnemyList();
          this.fetchPlayerDeck();
      },
      computed: {
          currentEnemy(){
              return this.enemyList.find((x)=>x.id===this.selectingEnemyId) || {};
          },
          enemyDeck(){
              return this.currentEnemy?.cards?.map((x)=>new Card(x.id, x.name, x.power, x.tech))
          },
          playerDeck(){
              // TODO: 8枚スライスはクラスカードの概念導入時に外す
              return this.playerDeckResponse?.map((x)=>new Card(x.id, x.name, x.power, x.tech)).slice(0, 8);
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

          fetchPlayerDeck(){
              const user_id = localStorage.user_id;
              const path = `/users/${user_id}/deck.json`;
              ax.get(path)
                  .then((results) => {
                      console.log(results);
                      console.log("OK");
                      this.playerDeckResponse = results.data.deck;
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

    .player_deck{
      position: absolute;
      left: 220px;
      top: 90px;
      width: 220px;
      height: 360px;
    }

    .enemy_deck{
      position: absolute;
      right: 220px;
      top: 90px;
      width: 220px;
      height: 360px;
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

    .open_magic_window{
      position: absolute;
      left: 230px;
      bottom: 75px;
      width: 170px;
      border-radius: $radius;
      @include centering($height: 30px);
      border: 1px solid $gray3;
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

    .player_magic_list{
      position: absolute;
      bottom: $thin_space;
      left: $thin_space;
    }
    .enemy_magic_list{
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
