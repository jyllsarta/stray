<template lang="pug">
  .menu
    .window.content
      .player_character
      .enemy_character
      .player_hands
      .enemy_hands
      .player_selecting_cards
      .enemy_selecting_cards
      .current_strength
      .player_status
      .enemy_status
      .player_magic_list
      .enemy_magic_list
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
    enemyName(){
      return this.battle?.enemy?.name || "-";
    },
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
* {
  outline: 1px solid #79f850;
}
.player_character{
  position: absolute;
  top: $space;
  left: 250px;
  width: 200px;
  height: 200px;
}
.enemy_character{
  position: absolute;
  top: $space;
  right: 250px;
  width: 200px;
  height: 200px;
}
.player_hands{
  position: absolute;
  top: 80px;
  left: $space;
  width: 200px;
  height: 310px;
}
.enemy_hands{
  position: absolute;
  top: 80px;
  right: $space;
  width: 200px;
  height: 310px;
}
.player_selecting_cards{
  position: absolute;
  top: 220px;
  left: 230px;
  width: 170px;
  height: 150px;
}
.enemy_selecting_cards{
  position: absolute;
  top: 220px;
  right: 230px;
  width: 170px;
  height: 150px;
}
.current_strength{
  position: absolute;
  top: 240px;
  left: 420px;
  width: 150px;
  height: 120px;
}
.player_status{
  position: absolute;
  top: 400px;
  left: 20px;
  width: 470px;
  height: 50px;
}
.enemy_status{
  position: absolute;
  top: 400px;
  right: 20px;
  width: 470px;
  height: 50px;
}
.player_magic_list{
  position: absolute;
  top: 460px;
  left: $space;
  width: 470px;
  height: 60px;
}
.enemy_magic_list{
  position: absolute;
  top: 460px;
  right: $space;
  width: 470px;
  height: 60px;
}
</style>
