<template lang="pug">
  .menu
    .full_covered_window
      .player_character
        img.tirol(src="/images/battle/tirol.png")
        img.spica(src="/images/battle/spica.png")
      .enemy_character
        img.enemy(src="/images/battle/enemy.png")
      .player_hands.hands
        .hand(
          v-for="card in playerHands"
          @click="battle.selectCard(card.id)"
          )
          Card(
            :name="card.name",
            :power="card.power()",
            :tech="card.tech()",
            :key="card.id",
            )
      .enemy_hands.hands
        Card(
          v-for="card in enemyHands",
          :name="card.name",
          :power="card.power()",
          :tech="card.tech()",
          :rightSide="true"
          :key="card.id",
        )
      .player_selecting_cards.hands
        .hand(
          v-for="card in playerSelectingCards"
          @click="battle.selectCard(card.id)"
          )
          Card(
            @click="battle.selectCard(card.id)",
            :name="card.name",
            :power="card.power()",
            :tech="card.tech()",
            :key="card.id",
          )
      .enemy_selecting_cards.hands
        Card(
          v-for="card in enemySelectingCards",
          :name="card.name",
          :power="card.power()",
          :tech="card.tech()",
          :key="card.id",
        )
      .decide(@click="playTurn()" :class="decideButtonClass")
        | Decide!
      .current_strength
        .player.strength
          .power
            | {{playerPower}}
          .tech
            | {{playerTech}}
        .sep
          .power
            | Pow
          .tech
            | Tec
        .enemy.strength
          .power
            | {{enemyPower}}
          .tech
            | {{enemyTech}}
      .player_status.status
        .hp
          | {{playerHp}}
        .mp
          | 100
        .bars
          .hp_bar
          .mp_bar
      .enemy_status.status
        .hp
          | {{enemyHp}}
        .mp
          | 100
        .bars
          .hp_bar
          .mp_bar
      MagicList(:isPlayer="true")
      MagicList(:isPlayer="false")
      transition(name="open_window")
        .result_popup(v-if="finished")
          .done.clickable(@click="endGame()")
            | OK
          img.result_image(:src="`/images/battle/outcome/${outcome}.png`")

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import BattleFactory from "./packs/quest/battle_factory"
import MagicList from "./MagicList.vue";
import Card from "./Card.vue";


export default {
  components: {
    MagicList,
    Card
  },
  data: function () {
    return {
      battle: {},
      input: null,
      finished: false,
      outcome: "",
    };
  },
  store,
  mounted(){
    this.postEngage();
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
    enemyHands(){
      return this.battle?.enemy?.deck?.currentHands() || [];
    },
    playerSelectingCards(){
      return this.battle.selectingCardIds?.map((cardId)=>this.battle.player.deck.findCard(cardId));
    },
    enemySelectingCards(){
      return this.battle.enemyCardIds?.map((cardId)=>this.battle.enemy.deck.findCard(cardId));
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

    postEngage(){
      const enemyId = this.$store.state.battle.enemy_id;
      const path = `/enemies/${enemyId}/engage.json`;
      ax.post(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.input = results.data;
          this.localBattleStart();
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
          this.finished = true;
          if(results.data.isDraw){
            this.outcome = "draw";
          }
          else if(results.data.isWin){
            this.outcome = "win";
          }
          else{
            this.outcome = "lose";
          }
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    endGame(){
        this.$store.commit("window/updateWindowShowState", {windowName: "battle_prepare", state: false})
        this.$store.commit("window/updateWindowShowState", {windowName: "battle", state: false})
    },
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
* {
  //outline: 1px solid #79f850;
}

.engage, .start{
  position: relative;
  z-index: 100;
  width: 200px;
  height: 50px;
  left: 600px;
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

.decide{
  text-align: center;
  padding-top: (35px - $font-size-normal) / 2;
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

.result_popup{
  position: absolute;
  width: 800px;
  top: 50px;
  left: ($window-width - 800px) / 2;
  .result_image{
    width: 100%;
  }
  .done{
    position: absolute;
    bottom: 80px;
    left: calc((100% - 150px) / 2);
    width: 150px;
    height: 50px;
    padding-top: (50px - $font-size-normal) / 2;
    line-height: 100%;
    text-align: center;
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
  top: 260px;
  left: calc( #{$window-width / 2} - 75px );
  width: 150px;
  height: 80px;
}
.decide{
  position: absolute;
  top: 330px;
  left: calc( #{$window-width / 2} - 75px );
  width: 150px;
  height: 40px;
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
  bottom: $space;
  left: $space;
  width: 500px;
  height: 65px;
}
.enemy_magic_list{
  position: absolute;
  bottom: $space;
  right: $space;
  width: 500px;
  height: 65px;
}
</style>
