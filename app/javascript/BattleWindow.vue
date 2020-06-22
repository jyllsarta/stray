<template lang="pug">
  .menu
    .full_covered_window
      .player_character
        img.tirol(src="/images/battle/tirol.png")
        img.spica(src="/images/battle/spica.png")
      .enemy_character
        img.enemy(src="/images/battle/enemy.png")
      .player_hands.hands
        .hand
          .name
            | ◆エリクシールハーフ
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆藻
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆がんもどき
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆竹馬
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆スリセルのロザリオ
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
      .enemy_hands.hands
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885

      .player_selecting_cards.hands
        .hand
          .name
            | ◆エリクシールハーフ
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆藻
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
      .enemy_selecting_cards.hands
        .hand
          .name
            | ◆エリクシールハーフ
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆藻
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆原初の炎
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
      .current_strength
        .player.strength
          .power
            | 999
          .tech
            | 999
        .sep
          .power
            | Pow
          .tech
            | Tec
        .enemy.strength
          .power
            | 999
          .tech
            | 999
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
  //outline: 1px solid #79f850;
}

// -- -- --

// スタイル定義

// -- -- --

.player_character{
  .spica{
    width: 200px;
    height: 200px;
    position: absolute;
  }
  .tirol{
    width: 200px;
    height: 200px;
    position: absolute;
    left: -50px;
  }
}

.enemy_character{
  .enemy{
    width: 200px;
    height: 200px;
  }
}

.hands{
  display: flex;
  flex-direction: column;
  .hand {
    padding: 2px;
    .value {
      display: flex;
      width: 100%;
      .sep {
        display: inline-block;
        width: 1em;
        text-align: center;
      }
      .value {
        display: inline-block;
        width: 2.5em;
        text-align: right;
      }
    }
    background-color: $background;
    &:hover {
      filter: brightness(130%);
    }
  }
}

.player_hands{
  .hand{
    @for $i from 1 through 8 {
      &:nth-child(#{$i}){
        padding-left: $i * 4px;
      }
    }
  }
}

.enemy_hands{
  text-align: right;
  .hand{
    .value{
      justify-content: flex-end;
    }
    @for $i from 1 through 8 {
      &:nth-child(#{$i}){
        padding-right: $i * 4px;
      }
    }
  }
}

.current_strength{
  display: flex;
  height: 100%;
  .strength{
    width: 35%;
    .power, .tech{
      text-align: center;
      height: 50%;
      font-size: $font-size-large;
    }
  }
  .sep{
    width: 30%;
    .power, .tech{
      text-align: center;
      height: 50%;
    }
  }
}

// -- -- --

// ウィンドウ位置定義

// -- -- --

.full_covered_window{
  position: absolute;
  width: $window-width;
  height: $window-height;
  background-color: $background;
  opacity: 1;
  padding: $space;
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
  width: 220px;
  height: 310px;
}
.enemy_hands{
  position: absolute;
  top: 80px;
  right: $space;
  width: 220px;
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
  top: 280px;
  left: 420px;
  width: 150px;
  height: 80px;
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
