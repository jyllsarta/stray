<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle', state: false})")
        .title
          | バトル！
      .body
        .start.clickable(@click="postEngage")
          | エンゲージ
        .start.clickable(@click="localBattleStart")
          | ローカルで戦闘してみる
        .start.clickable(@click="postShowdown")
          | ショウダウン
        .player_hp
          | PlayerHp : {{playerHp}}
        .enemy_hp
          | EnemyHp : {{enemyHp}}
        .hands
          .hand(v-for="hand in playerHands" @click="battle.selectCard(hand.id)" :class="[selectingClass(hand.id)]")
            | {{hand.id}} / 名:{{hand.name}} / p:{{hand.power()}} / t:{{hand.tech()}}
        .history
          | operationHistory: {{battle.operationHistory}}
        .selecting_cards
          | selectingCardIds: {{battle.selectingCardIds}}
        .current_power
          | currentPower: {{playerPower}}
        .current_tech
          | currentTech: {{playerTech}}
        .enemy_selecting_cards
          | selectingCardIds: {{battle.enemyCardIds}}
        .enemy_current_power
          | enemyCurrentPower: {{enemyPower}}
        .enemy_current_tech
          | enemyCurrentTech: {{enemyTech}}
        .play_turn(@click="playTurn" :class="decideButtonClass")
          | Decide!
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import BattleFactory from "./packs/quest/battle_factory"


export default {
  data: function () {
    return {
      battle: {},
      input: null,
    };
  },
  store,
  mounted(){
  },
  computed: {
    playerHp(){
      return this.battle?.player?.hp || 0;
    },
    enemyHp(){
      return this.battle?.enemy?.hp || 0;
    },
    playerHands(){
      return this.battle?.player?.deck?.currentHands() || [];
    },
    playerPower(){
      return this.battle.player?.powerAt(this.battle.selectingCardIds);
    },
    playerTech(){
      return this.battle.player?.techAt(this.battle.selectingCardIds);
    },
    enemyPower(){
      return this.battle.enemy?.powerAt(this.battle.enemyCardIds);
    },
    enemyTech(){
      return this.battle.enemy?.techAt(this.battle.enemyCardIds);
    },

    isDecidable(){
      return this.battle.selectingCardIds?.length === 3;
    },

    decideButtonClass(){
      return this.isDecidable ? "clickable" : "";
    }
  },
  methods: {
    localBattleStart(){
      if(!this.input){
        console.warn("まだエンゲージしてない");
        return;
      }
      this.battle = new BattleFactory(this.input).getBattle();
    },

    playTurn(){
      if(!this.isDecidable){
        console.log("ちゃんと3まいきっかり選んで");
        return;
      }
      this.battle.playTurn();
      if(this.battle.isGameEnd()){
        console.log("決着！ショーダウン!");
        console.log(this.input.seed);
        console.log(this.battle.battleLog);
        this.postShowdown();
      }
    },

    selectingClass(cardId){
      return this.battle.selectingCardIds.includes(cardId) ? "selecting" : "";
    },

    postEngage(){
      const path = `/enemies/-1/engage.json`;
      ax.post(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.input = results.data;
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },

    postShowdown(){
      const path = `/enemies/-1/showdown.json`;
      const params = {
        operation_history: this.battle.operationHistory
      };
      ax.post(path, params)
        .then((results) => {
          console.log(results);
          console.log("OK");
          console.log(`サーバでの戦闘結果： isWin: ${results.data.isWin}`);
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
  .body{
    .start{
      width: 300px;
      height: 30px;
      text-align: center;
    }
    .hands{
      display: flex;
      .hand{
        margin: $thin_space;
        padding: $space;
      }
      .selecting{
        background-color: $gray2;
      }
    }
  }
</style>
