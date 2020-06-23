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
            | ◆つつく
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆のびる
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆爪
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆マシンガンα
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆召喚魔法
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆レーザービーム
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆ソードブレイカー
          .value
            .power.value
              | 194
            .sep
              | /
            .tech.value
              | 885
        .hand
          .name
            | ◆ミラーミラー
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
      .player_status.status
        .hp
          | 4
        .mp
          | 100
        .bars
          .hp_bar
          .mp_bar
      .enemy_status.status
        .hp
          | 18
        .mp
          | 100
        .bars
          .hp_bar
          .mp_bar
      .player_magic_list.magic_list
        .magic
          .name
            | プロテクト
          .cost
            | 40∞
        .magic
          .name
            | 雷撃
          .cost
            | 70∞
        .magic
          .name
            | 必殺 -桜花-
          .cost
            | 100
        .magic
          .name
            | 霊撃
          .cost
            | 100
        .magic
          .name
            | 応急治療
          .cost
            | 40
      .enemy_magic_list.magic_list
        .magic
          .name
            | 粘液
          .cost
            | 40
        .magic
          .name
            | 自然治癒
          .cost
            | 70∞
        .magic
          .name
            | 弱電撃
          .cost
            | 30∞
        .magic
          .name
            | 崩壊
          .cost
            | 80
        .magic
          .name
            | 大　壊　滅
          .cost
            | 100∞
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
    width: 256px;
    height: 256px;
    position: absolute;
  }
  .tirol{
    width: 256px;
    height: 256px;
    position: absolute;
    left: -50px;
  }
}

.enemy_character{
  .enemy{
    width: 256px;
    height: 256px;
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
        padding-left: $i * 6px;
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
        padding-right: $i * 6px;
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

.status{
  .hp{
    position: absolute;
    top: -35px;
    font-size: 40px;
  }
  .mp{
    position: absolute;
    top: 20px;
    font-size: $font-size-normal;
  }
  .bars{
    width: 100%;
    height: 50px;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    .hp_bar{
      width: 400px;
      height: 4px;
      background-color: #FCD99A;
    }
    .mp_bar{
      width: 250px;
      height: 4px;
      background-color: #c5b4fc;
    }
  }
}

.player_status{
  .hp, .mp{
    right: 10px;
  }
  .bars{
    align-items: flex-end;
  }
}

.enemy_status{
  .hp, .mp{
    left: 10px;
  }
  .bars{
    align-items: flex-start;
  }
}

.magic_list{
  display: flex;
  .magic{
    margin: $thin_space / 2;
    padding: $thin_space / 2;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    border: 1px solid $gray3;
    border-radius: $radius;
    width: 90px;
    height: 60px;
    .name, .cost{
      text-align: center;
    }
  }
}

.player_magic_list{
  justify-content: flex-start;
}

.enemy_magic_list{
  justify-content: flex-end;
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
  top: 0;
  left: 230px;
  width: 256px;
  height: 256px;
}
.enemy_character{
  position: absolute;
  top: 0;
  right: 230px;
  width: 256px;
  height: 256px;
}
.player_hands{
  position: absolute;
  top: 40px;
  left: $space;
  width: 220px;
  height: 310px;
}
.enemy_hands{
  position: absolute;
  top: 40px;
  right: $space;
  width: 220px;
  height: 310px;
}
.player_selecting_cards{
  position: absolute;
  top: 260px;
  left: 250px;
  width: 170px;
  height: 150px;
}
.enemy_selecting_cards{
  position: absolute;
  top: 260px;
  right: 250px;
  width: 170px;
  height: 150px;
}
.current_strength{
  position: absolute;
  top: 280px;
  left: calc( #{$window-width / 2} - 75px );
  width: 150px;
  height: 80px;
}
.player_status{
  position: absolute;
  top: 420px;
  left: 20px;
  width: 470px;
  height: 50px;
}
.enemy_status{
  position: absolute;
  top: 420px;
  right: 20px;
  width: 470px;
  height: 50px;
}
.player_magic_list{
  position: absolute;
  top: 480px;
  left: $space;
  width: 500px;
  height: 65px;
}
.enemy_magic_list{
  position: absolute;
  top: 480px;
  right: $space;
  width: 500px;
  height: 65px;
}
</style>
