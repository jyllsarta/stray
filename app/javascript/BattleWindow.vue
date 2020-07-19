<template lang="pug">
  .menu
    .full_covered_window
      .player_character
        img.tirol(src="/images/battle/tirol.png")
        img.spica(src="/images/battle/spica.png")
        img.player_barrier(v-if="playerShield > 0" src="/images/battle/barrier.png")
      .enemy_character
        img.enemy(src="/images/battle/enemy.png")
        img.enemy_barrier(v-if="enemyShield > 0" src="/images/battle/barrier.png")
      CardList.player_hands(
        :cards="playerHands"
        :right-side="false"
        @onClick="selectCard"
      )
      CardList.enemy_hands(
        :cards="enemyHands"
        :right-side="true"
      )
      CardList.player_selecting_cards(
        :cards="playerSelectingCards"
        :right-side="false"
        @onClick="selectCard"
      )
      CardList.enemy_selecting_cards(
        :cards="enemySelectingCards"
        :right-side="true"
      )
      .decide(@click="playTurn()" :class="decideButtonClass")
        | Decide!
      .skill_name(:key="skillName")
        .pre
        .text
          | {{skillName}}
        .after
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
        .shield(v-if="playerShield > 0")
          img.icon(src="/images/icons/misc/shield.gif")
          .value
            | {{playerShield}}
        .hp
          | {{playerHp}}
        .mp
          | {{playerMp}}
        .bars
          Slider(:width="400", :ratio="playerHpRatio", :reversed="true", :main-color="colors.hpColor", :blank-color="colors.hpBlankColor" )
          Slider(:width="250", :ratio="playerMpRatio", :reversed="true", :main-color="colors.mpColor", :blank-color="colors.mpBlankColor" )
      .enemy_status.status
        .shield(v-if="enemyShield > 0")
          img.icon(src="/images/icons/misc/shield.gif")
          .value
            | {{enemyShield}}
        .hp
          | {{enemyHp}}
        .mp
          | {{enemyMp}}
        .bars
          Slider(:width="400", :ratio="enemyHpRatio", :main-color="colors.hpColor", :blank-color="colors.hpBlankColor" )
          Slider(:width="250", :ratio="enemyMpRatio", :main-color="colors.mpColor", :blank-color="colors.mpBlankColor" )
      BattleSkillList(:isPlayer="true", :skills="playerSkills" @onClick="selectSkill", :battle="battle")
      BattleSkillList(:isPlayer="false", :skills="enemySkills", :battle="battle")
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
import BattleSkillList from "./BattleSkillList.vue";
import CardList from "./CardList.vue";
import Slider from "./Slider.vue";


export default {
  components: {
    BattleSkillList,
    CardList,
    Slider,
  },
  data: function () {
    return {
      battle: {},
      input: null,
      finished: false,
      outcome: "",
      skillName: "",
      colors: {
        hpColor: "rgba(255,192,145,0.99)",
        hpBlankColor: "rgba(255,192,145,0.22)",
        mpColor: "rgba(145,229,255,0.99)",
        mpBlankColor: "rgba(145,229,255,0.22)",
      }
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
    playerShield(){
      return this.battle?.player?.tempBuffs?.shield || 0;
    },
    enemyShield(){
      return this.battle?.enemy?.tempBuffs?.shield || 0;
    },
    playerHpRatio(){
      return this.battle?.player?.hpRatio()  || 0;
    },
    enemyHpRatio(){
      return this.battle?.enemy?.hpRatio() || 0;
    },
    playerMpRatio(){
        return this.battle?.player?.mpRatio() || 0;
    },
    enemyMpRatio(){
        return this.battle?.enemy?.mpRatio() || 0;
    },
    playerMp(){
      return this.battle?.player?.mp || 0;
    },
    enemyMp(){
      return this.battle?.enemy?.mp || 0;
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
    playerSkills(){
        return this.battle.player?.skills;
    },
    enemySkills(){
        return this.battle.enemy?.skills;
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

    selectCard(cardId){
        this.battle?.selectCard(cardId);
    },

    selectSkill(skillId){
        this.battle?.selectSkill(skillId);
    },

    playTurn(){
      if(!this.isDecidable){
        console.log("ちゃんと3まいきっかり選んで");
        return;
      }

      this.battle.onTurnStart();

      Promise.resolve()
        .then(()=>{
          return new Promise((resolve) => {
            setTimeout( ()=>{
              this.battle.invokePlayerMagic();
              this.skillName = "プレイヤー魔法";
              resolve();
            }, 0);
          });
        })
        .then(()=>{
          return new Promise((resolve) => {
            setTimeout(()=>{
              this.battle.invokeEnemyMagic();
              this.skillName = "敵魔法";
              resolve();
            }, 800);
          });
        })
        .then(()=>{
          return new Promise((resolve) => {
            setTimeout(()=>{
              this.battle.invokePowerAttack();
              this.skillName = "力判定！";
              resolve();
            }, 500);
          });
        })
        .then(()=>{
          return new Promise((resolve) => {
            setTimeout(()=>{
              this.battle.invokeTechAttack();
              this.skillName = "技判定！";
              resolve();
            }, 500);
          });
        })
        .then(()=>{
          return new Promise((resolve) => {
            setTimeout(()=>{
              this.battle.invokeSPAttack();
              this.skillName = "SPアタック！";
              resolve();
            }, 500);
          });
        })
        .then(()=>{
          return new Promise((resolve) => {
            setTimeout(()=>{
              this.battle.onTurnEnd();
              resolve();
            }, 10);
          });
        })
        .then(()=>{
          return new Promise((resolve) => {
            setTimeout(()=>{
              this.checkGameEnd();
              resolve();
            }, 10);
          });
        });
    },

    checkGameEnd(){
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
      const params = {
        enemy_id: enemyId
      };
      ax.post(path, params)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.input = results.data;
          this.localBattleStart();
          // バトルデバッグ用に開発環境ではwindowにダイレクトアタックでバックドアを仕込む
          if (process.env.NODE_ENV !== 'production') {
            window.battle = this.battle;
          }
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
  .player_barrier{
    width: 256px;
    height: 256px;
    position: absolute;
    left: 50px;
  }
}

.enemy_character{
  .enemy{
    width: 256px;
    height: 256px;
  }
  .enemy_barrier{
    width: 256px;
    height: 256px;
    position: absolute;
    left: -50px;
    transform: scale(-1,1);
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
  }
}

.decide{
  text-align: center;
  padding-top: (35px - $font-size-normal) / 2;
}

.player_status{
  .shield{
    position: absolute;
    top: -55px;
    right: 30px;
    .icon, .value{
      display: inline-block;
      font-size: $font-size-large;
    }
  }
  .hp, .mp{
    right: 10px;
  }
  .bars{
    align-items: flex-end;
  }
}

.enemy_status{
  .shield{
    position: absolute;
    top: -55px;
    left: 30px;
    .icon, .value{
      font-size: $font-size-large;
      display: inline-block;
    }
  }
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

@keyframes skill-name {
  0% {
    transform: translateY(5px);
    opacity: 0;
  }
  10% {
    transform: translateY(0px);
    opacity: 1;
  }
  93% {
    transform: translateY(0px);
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}
.skill_name {
  text-align: center;
  animation: skill-name 1s cubic-bezier(.17,.67,.83,.67) 0s;
  height: 100%;
  display: flex;
  opacity: 0;
  .pre, .after{
    width: 20px;
    height: 100%;
  }
  .pre{
    background: linear-gradient(to right, $gray3 0%, transparent 100%);
  }
  .after{
    background: linear-gradient(to left, $gray3 0%, transparent 100%);
  }
  .text{
    flex: 1;
    height: 100%;
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
.skill_name{
  position: absolute;
  top: 20px;
  left: calc( #{$window-width / 2} - 75px );
  width: 150px;
  height: 20px;
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
.player_skill_list{
  position: absolute;
  bottom: $space;
  left: $space;
  width: 500px;
  height: 65px;
}
.enemy_skill_list{
  position: absolute;
  bottom: $space;
  right: $space;
  width: 500px;
  height: 65px;
}
</style>
