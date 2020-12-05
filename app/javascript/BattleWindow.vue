<template lang="pug">
  .menu
    .full_covered_window(@click.right.prevent="removeLastCard")
      .background_fields
        img.background_field(src="/images/battle/background.png" :class="isTurnInProgress ? 'zoomed' : 'normal'")
      transition(name="open_window")
        .show_battle_menu.clickable(v-if="!showMenu" @click="showMenu = true")
          | メニュー
      transition(name="open_window")
        .battle_menu(v-if="showMenu")
          .back(@click="showMenu = false")
          .items
            .item.clickable(@click="showMenu = false")
              | メニューをとじる
            .item.clickable(@click="retire()")
              | 諦める
      .player_character
        .tirol
          BattleCharacter(
            :character-name="'tirol'"
            :images="{normal: 'normal', magic:'magic', default: 'default'}"
            :status="tirolStatus"
            :isPlayer="true"
            :currentSkillName="skillName"
          )
        .spica
          BattleCharacter(
            :character-name="'spica'"
            :images="{normal: 'normal', attack:'attack',  attack2:'attack2',  attack3:'attack3', draw:'draw', lose:'lose', default: 'default'}"
            :status="spicaStatus"
            :isPlayer="true"
            :currentSkillName="skillName"
            :shield="playerShield > 0"
            )
      .enemy_character
        BattleCharacter(
          :character-name="enemyImageName"
          :images="enemyImageLibrary",
          :status="enemyStatus"
          :isPlayer="false"
          :currentSkillName="skillName"
          :shield="enemyShield > 0"
        )
      CardList.player_hands(
        :cards="playerHands"
        :right-side="false"
        @onClick="selectCard"
        :global-disabled="isPlayerCardLocked"
      )
      CardList.enemy_hands(
        :cards="enemyHands"
        :right-side="true"
      )
      CardList.player_selecting_cards(
        :cards="playerSelectingCards"
        :right-side="false"
        @onClick="selectCard"
        :global-disabled="isPlayerCardLocked"
      )
      CardList.enemy_selecting_cards(
        :cards="enemySelectingCards"
        :right-side="true"
      )
      .decide(@click="playTurn()" :class="decideButtonClass")
        | ターン開始
      .skill_name(:key="skillName")
        .pre
        .text
          | {{skillName}}
        .after
      .current_strength
        .power.strength
          .player(:class="[playerPower > enemyPower ? 'win' : '', isStrengthFlashing('player', 'power') ? 'flash' : '']", :key="'playerPower'+turnStatus")
            NumeratableNumber(:number="playerPower", :speed="0.4" )
          .sep
            | 力
          .enemy(:class="[playerPower < enemyPower ? 'win' : '', isStrengthFlashing('enemy', 'power') ? 'flash' : '']", :key="'enemyPower'+turnStatus")
            NumeratableNumber(:number="enemyPower", :speed="0.4")
        .tech.strength
          .player(:class="[playerTech > enemyTech ? 'win' : '', isStrengthFlashing('player', 'tech') ? 'flash' : '']", :key="'playerTech'+turnStatus")
            NumeratableNumber(:number="playerTech", :speed="0.4")
          .sep
            | 技
          .enemy(:class="[playerTech < enemyTech ? 'win' : '', isStrengthFlashing('enemy', 'tech') ? 'flash' : '']", :key="'enemyTech'+turnStatus")
            NumeratableNumber(:number="enemyTech", :speed="0.4")
      .player_status.status
        .shield(v-if="playerShield > 0")
          img.icon(src="/images/icons/misc/shield.gif")
          .value
            | {{playerShield}}
        .hps
          .hp
            NumeratableNumber(:number="playerHp")
          .hp_max
            | / {{playerHpMax}}
        .mp
          NumeratableNumber(:number="playerMp")
        .bars
          Slider(
            :width="400",
            :height="4",
            :ratio="playerHpRatio",
            :reversed="true",
            :main-color="colors.hpColor",
            :blank-color="colors.hpBlankColor",
            :damage-color="colors.damageColor",
            :update-delayms="parameters.hpDelay",
            :update-ratio="parameters.updateRatio",
          )
          Slider(
            :width="250",
            :height="4",
            :ratio="playerMpRatio",
            :reversed="true",
            :main-color="colors.mpColor",
            :blank-color="colors.mpBlankColor",
            :damage-color="colors.damageColor",
            :update-delayms="1",
            :update-ratio="parameters.updateRatio",
          )
        .ghost_bars
          Slider(
            :width="380", 
            :height="1",
            :ratio="playerHpRatio - 1",
            :reversed="true",
            :main-color="colors.hpColor",
            :blank-color="colors.hpBlankColor",
            :damage-color="colors.damageColor",
            :update-delayms="parameters.hpDelay",
            :update-ratio="parameters.updateRatio",
          )
          Slider(
            :width="250",
            :height="1",
            :ratio="playerMpRatio - 1",
            :reversed="true",
            :main-color="colors.mpColor",
            :blank-color="colors.mpBlankColor"
            :damage-color="colors.damageColor",
            :update-delayms="1",
            :update-ratio="parameters.updateRatio",
          )
        .damage_parameters
          DamageParameters(:power="playerPowerDamage", :tech="playerTechDamage", :special="playerSpecialDamage", :basic-power="playerBasicPowerDamage", :basic-tech="playerBasicTechDamage", :basic-special="playerBasicSpecialDamage")
      .enemy_status.status
        .shield(v-if="enemyShield > 0")
          img.icon(src="/images/icons/misc/shield.gif")
          .value
            | {{enemyShield}}
        .hps
          .hp
            NumeratableNumber(:number="enemyHp")
          .hp_max
            | / {{enemyHpMax}}
        .mp
          NumeratableNumber(:number="enemyMp")
        .bars
          Slider(
            :width="400",
            :height="4",
            :ratio="enemyHpRatio",
            :main-color="colors.hpColor",
            :blank-color="colors.hpBlankColor",
            :damage-color="colors.damageColor",
            :update-delayms="parameters.hpDelay",
            :update-ratio="parameters.updateRatio",
          )
          Slider(
            :width="250",
            :height="4",
            :ratio="enemyMpRatio",
            :main-color="colors.mpColor",
            :blank-color="colors.mpBlankColor",
            :damage-color="colors.damageColor",
            :update-delayms="1",
            :update-ratio="parameters.updateRatio",
          )
        .ghost_bars
          Slider(
            :width="380",
            :height="1",
            :ratio="enemyHpRatio - 1",
            :main-color="colors.hpColor",
            :blank-color="colors.hpBlankColor",
            :damage-color="colors.damageColor",
            :update-delayms="parameters.hpDelay",
            :update-ratio="parameters.updateRatio",
          )
          Slider(
            :width="250",
            :height="1",
            :ratio="enemyMpRatio - 1",
            :main-color="colors.mpColor",
            :blank-color="colors.mpBlankColor",
            :damage-color="colors.damageColor",
            :update-delayms="1",
            :update-ratio="parameters.updateRatio",
          )
        .damage_parameters
          DamageParameters(:power="enemyPowerDamage", :tech="enemyTechDamage", :special="enemySpecialDamage", :basic-power="enemyBasicPowerDamage", :basic-tech="enemyBasicTechDamage", :basic-special="enemyBasicSpecialDamage")
      SkillList(:isPlayer="true", :skills="playerSkills" @onClick="selectSkill", :battle="battle")
      SkillList(:isPlayer="false", :skills="enemySkills", :battle="battle")
      .fragments
        TurnStart(v-if="$store.state.battle.fragments.turn_start")
      transition(name="open_window")
        .result_popup(v-if="finished")
          .done.clickable(@click="endGame()")
            | OK
          img.result_image(:src="`/images/battle/outcome/${outcome}.png`")
          .rewards(v-if="outcome==='win'" :class="[rewardRevealed ? '' : 'unclicked']" @click="rewardRevealed = true")
            span.descri
              | 撃破報酬：
            .reward(v-for="reward in rewards")
              .ques(v-if="!rewardRevealed")
                | ???
              .count(v-if="rewardRevealed")
                | {{ reward }}
            span.nothing(v-if="!rewards && outcome==='win'")
              | なし
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import BattleFactory from "./packs/quest/battle_factory"
import SkillList from "./SkillList.vue";
import CardList from "./CardList.vue";
import Slider from "./Slider.vue";
import DamageParameters from "./DamageParameters.vue";
import BattleCharacter from "./BattleCharacter.vue";
import NumeratableNumber from "./NumeratableNumber.vue";
import TurnStart from "./fragments/TurnStart.vue";


export default {
  components: {
    SkillList,
    CardList,
    Slider,
    DamageParameters,
    BattleCharacter,
    NumeratableNumber,
    TurnStart,
  },
  data: function () {
    return {
      battle: {},
      input: null,
      finished: false,
      outcome: "",
      rewardRevealed: false,
      rewards: [],
      skillName: "戦闘開始！", // アニメーションが毎度発火してしまうので、戦闘開始時にそれっぽいスキル表示が出ることにしてごまかす
      colors: {
        hpColor: "rgba(255,192,145,0.99)",
        hpBlankColor: "rgba(255,192,145,0.32)",
        mpColor: "rgba(145,229,255,0.99)",
        mpBlankColor: "rgba(145,229,255,0.32)",
        damageColor: "rgba(255,255,255,1)",
      },
      parameters: {
        hpDelay: 100,
        updateRatio: 0.3,
      },
      showMenu: false,
    };
  },
  store,
  mounted(){
    this.postEngage();
  },
  computed: {
    isPlayerCardLocked(){
      return this.battle?.turnInProgress;
    },
    isTurnInProgress(){
      return this.battle?.turnInProgress;
    },
    turnStatus(){
      return this.battle?.turnStatus || "selectCard";
    },
    enemyName(){
      return this.battle?.enemy?.name || "faily";
    },
    enemyImageName(){
      return this.battle?.enemy?.imageName || "faily";
    },
    enemyImageLibrary(){
      return Constants.battleCharacter.imageLibrary[this.enemyImageName] || {};
    },
    playerHp(){
      return this.battle?.player?.hp || 0;
    },
    playerHpMax(){
      return this.battle?.player?.hp_max || 0;
    },
    enemyHp(){
      return this.battle?.enemy?.hp || 0;
    },
    enemyHpMax(){
      return this.battle?.enemy?.hp_max || 0;
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
      return this.battle?.player?.deck?.currentHands()?.filter((x)=>!this.battle?.selectingCardIds?.includes(x.id)) || [];
    },
    enemyHands(){
      return this.battle?.enemy?.deck?.currentHands()?.filter((x)=>!this.battle?.enemyCardIds?.includes(x.id)) || [];
    },
    playerSelectingCards(){
      return this.battle.selectingCardIds?.map((cardId)=>this.battle.player.deck.findCard(cardId));
    },
    enemySelectingCards(){
      return this.battle.enemyCardIds?.map((cardId)=>this.battle.enemy.deck.findCard(cardId));
    },
    playerPower(){
      return this.battle.player?.powerAt(this.battle.selectingCardIds) || 0;
    },
    playerTech(){
      return this.battle.player?.techAt(this.battle.selectingCardIds) || 0;
    },
    enemyPower(){
      return this.battle.enemy?.powerAt(this.battle.enemyCardIds) || 0;
    },
    enemyTech(){
      return this.battle.enemy?.techAt(this.battle.enemyCardIds) || 0;
    },
    playerPowerDamage(){
      return this.battle.player?.damageAt("power");
    },
    playerTechDamage(){
      return this.battle.player?.damageAt("tech");
    },
    playerSpecialDamage(){
      return this.battle.player?.damageAt("special");
    },
    playerBasicPowerDamage(){
      return this.battle.player?.power;
    },
    playerBasicTechDamage(){
      return this.battle.player?.tech;
    },
    playerBasicSpecialDamage(){
      return this.battle.player?.special;
    },
    enemyPowerDamage(){
      return this.battle.enemy?.damageAt("power");
    },
    enemyTechDamage(){
      return this.battle.enemy?.damageAt("tech");
    },
    enemySpecialDamage(){
      return this.battle.enemy?.damageAt("special");
    },
    enemyBasicPowerDamage(){
      return this.battle.enemy?.power;
    },
    enemyBasicTechDamage(){
      return this.battle.enemy?.tech;
    },
    enemyBasicSpecialDamage(){
      return this.battle.enemy?.special;
    },
    playerSkills(){
      return this.battle.player?.skills;
    },
    enemySkills(){
      return this.battle.enemy?.skills;
    },
    spicaStatus(){
      return this.battle?.characterStatus?.spica || 'normal';
    },
    tirolStatus(){
      return this.battle?.characterStatus?.tirol || 'normal';
    },
    enemyStatus(){
      return this.battle?.characterStatus?.enemy || 'normal';
    },
    isDecidable(){
      return this.battle.selectingCardIds?.length === 3 && this.battle.turnInProgress === false;
    },
    decideButtonClass(){
      return this.isDecidable ? "startable" : "disabled";
    }
  },
  methods: {

    // **
    // Controllers
    // **

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

    removeLastCard(){
      if(this.battle.selectingCardIds.length === 0){
        return;
      }
      this.battle?.selectCard(this.battle.selectingCardIds.slice(-1)[0]);
    },

    selectSkill(emittedObject){
      const skillIndex = emittedObject.skillIndex;
      this.battle?.selectSkill(skillIndex);
    },

    retire(){
      this.outcome = "retired";
      this.endGame();
    },

    endGame(){
        this.$store.commit("window/updateWindowShowState", {windowName: "battle_prepare", state: false});
        this.$store.commit("window/updateWindowShowState", {windowName: "battle", state: false});
        this.$store.commit("window/updateWindowShowState", {windowName: "quest", state: false});
        this.$store.commit("event/addEventLog", {message: this.getLogMessage()});
        this.$store.dispatch('user/fetchUserModel'); // 報酬の反映
    },

    // **
    // Turn Sequences
    // ** 

    playTurnStartPhase(){
      return new Promise((resolve) => {
        this.$store.commit("battle/showFragment", "turn_start");
        setTimeout( ()=>{
          resolve();
        }, 800);
      });
    },

    playPlayerSkillPhase(){
      return new Promise((resolve) => {
        // プレイヤー魔法を使っていなかったらスルー
        if(this.battle.player.selectingSkillIndex === null){
          resolve();
          return;
        }
        this.battle.invokePlayerMagic();
        this.skillName = "プレイヤー魔法";
        setTimeout( ()=>{
          resolve();
        }, 1000);
      });
    },

    playEnemySkillPhase(){
      return new Promise((resolve) => {
        // 敵が魔法を使っていなかったらスルー
        if(this.battle.enemy.selectingSkillIndex === null){
          resolve();
          return;
        }
        this.battle.invokeEnemyMagic();
        this.skillName = "敵魔法";
        setTimeout(()=>{
          resolve();
        }, 1000);
      });
    },

    playAttackPhase(){
      return new Promise((resolve) => {
        Promise.resolve()
        .then(()=>{
          return new Promise((resolve) => {
            this.battle.invokePowerAttack();
            this.skillName = "力判定！";
            setTimeout(()=>{
              resolve();
            }, 700);
          });
        })
        .then(()=>{
          return new Promise((resolve) => {
            this.battle.invokeTechAttack();
            this.skillName = "技判定！";
            setTimeout(()=>{
              resolve();
            }, 700);
          });
        })
        .then(()=>{
          return new Promise((resolve) => {
            if(!this.battle.isSPAttackWillHappen()){
              resolve();
              return;
            }

            this.battle.invokeSPAttack();
            this.skillName = "SPアタック！";
            setTimeout(()=>{
              resolve();
            }, 700);
          });
        })
        .then(()=>{
          resolve(); // めちゃわかりにくいけど親promiseのresolve
        })
      });
    },

    playEndPhase(){
      return new Promise((resolve) => {
        this.battle.onTurnEnd();
        setTimeout(()=>{
          resolve();
        }, 700);
      });
    },

    playCheckGameEndPhase(){
      return new Promise((resolve) => {
        this.checkGameEnd();
        resolve();
      });
    },

    playTurn(){
      if(!this.isDecidable){
        console.log("ちゃんと3まいきっかり選んで");
        return;
      }
      this.battle.onTurnStart();
      Promise.resolve()
        .then(()=>{
          return this.playTurnStartPhase();
        })
        .then(()=>{
          return this.playPlayerSkillPhase();
        })
        .then(()=>{
          return this.playEnemySkillPhase();
        })
        .then(()=>{
          return this.playAttackPhase();
        })
        .then(()=>{
          return this.playEndPhase();
        })
        .then(()=>{
          return this.playCheckGameEndPhase();
        });
    },


    // **
    // API calls
    // **

    postEngage(){
      const enemyId = this.$store.state.battle.enemy_id;
      const path = `/enemies/${enemyId}/engage.json`;
      const params = {
        enemy_id: enemyId
      };
      ax.post(path, params)
        .then((results) => {
          console.log(results);
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
          console.log(`サーバでの戦闘結果： isWin: ${results.data.isWin}`);
          this.finished = true;
          this.rewards = results.data.rewards;
          if(results.data.isDraw){
            this.outcome = "draw";
          }
          else if(results.data.isWin){
            this.outcome = "win";
          }
          else{
            this.outcome = "lose";
          }
          this.$store.dispatch("achievement/fetchAchievements");
          this.$store.dispatch("achievement/fetchAchievementCache");
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },

    // **
    // Private Utility
    // **

    checkGameEnd(){
      if(this.battle.isGameEnd()){
        console.log("決着！ショーダウン!");
        console.log(this.input.seed);
        console.log(this.battle.battleLog);
        this.postShowdown();
      }
    },

    getLogMessage(){
      switch (this.outcome) {
        case "win":
          return `${this.enemyName}と戦闘し勝利した！`;
        case "draw":
          return `${this.enemyName}と戦闘し引き分けた...`;
        case "lose":
          return `${this.enemyName}と戦闘し敗北した...`;
        case "retired":
          return `${this.enemyName}と戦闘したが撤退した！`;
        default:
          console.warn(`undefined outcome ${this.outcome}`);
          return "何かエラーが起きたみたい！";
      }
    },

    isStrengthFlashing(side, parameterName){
      switch(this.battle?.turnStatus){
        case "powerAttack":
          if(side == "player" && this.playerPower > this.enemyPower){
            return parameterName == 'power';
          }
          if(side == "enemy" && this.playerPower < this.enemyPower){
            return parameterName == 'power';
          }
          return false;
        case "techAttack":
          if(side == "player" && this.playerTech > this.enemyTech){
            return parameterName == 'tech';
          }
          if(side == "enemy" && this.playerTech < this.enemyTech){
            return parameterName == 'tech';
          }
          return false;
        case "SPAttack":
          if(side == "player" && (this.playerPower > this.enemyPower) && (this.playerTech > this.enemyTech)){
            return true;
          }
          if(side == "enemy" && (this.playerPower < this.enemyPower) && (this.playerTech < this.enemyTech)){
            return true;
          }
          return false;
        default:
          return false;
      }
    },
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";

// -- -- --

// スタイル定義

// -- -- --

.show_battle_menu{
  position: absolute;
  top: $space;
  right: $space;
  @include centering($height:35px);
  width: 160px;
}

.battle_menu{
  position: absolute;
  top: $space;
  right: $space;
  width: 160px;
  .back{
    position: absolute;
    left: -1000px; // 起点がダメすぎてきつい宣言になった...
    top: -100px;
    width: 100vw;
    height: 100vh;
  }
  .items{
    position: relative;
    width: 100%;
    display: flex;
    flex-direction: column;
    .item{
      width: 100%;
      @include centering($height:35px);
      margin-bottom: $thin_space;
    }
  }
}

.background_fields{
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  .background_field {
    position: absolute;
    width:70%;
    left: 15%;
    top: -50%;
    transform-origin: bottom;
  }
  .zoomed{
    transition: transform 0.6s;
    transform: scale(1.3);
  }
  .normal{
    transition: transform 0.6s;
    transform: scale(1);
  }
}

.player_character{
  pointer-events: none;
  .spica{
    width: 256px;
    height: 256px;
    position: absolute;
    left: 60px;
  }
  .tirol{
    width: 256px;
    height: 256px;
    position: absolute;
    left: -50px;
  }
}

.enemy_character{
  pointer-events: none;
  .enemy{
    width: 256px;
    height: 256px;
  }
}

.current_strength{
  height: 100%;
  .strength{
    display: flex;
    width: 100%;
    align-items: baseline;
    height: 30px;

    .player, .enemy{
      width: 30%;
      text-align: center;
      font-size: $font-size-large;
    }
    .sep{
      text-align: center;
      width: 40%;
    }
    .win{
      color: $yellow;
      font-size: $font-size-large + 2px; // すこーしだけ大きくする、の意
    }
    .flash{
      animation: flash .5s cubic-bezier(.33,.81,.62,.92);
    }
  }

  @keyframes flash {
    0% {
      transform: scale(2);
      opacity: 0.4;
    }
    100% {
      transform: scale(1);
      opacity: 1;
    }
  }
}

.status{
  .hps{
    position: absolute;
    top: -30px;
    .hp{
      text-align: right;
      display: inline-block;
      margin-right: $thin_space;
      font-size: 40px;
    }
    .hp_max{
      display: inline-block;
      font-size: $font-size-normal;
    }
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
  .ghost_bars{
    position: absolute;
    top: -4px;
    width: 100%;
    height: 50px;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
  }
}

.decide{
  @include centering($height: 40px);
  border: 1px solid $gray3;
  border-radius: $radius;
  &.startable{
    border: 1px solid $yellow;
    background-color: $gray3;
    cursor: pointer;
  }
  &.disabled{
    opacity: 0.5;
    cursor: default;
  }
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
  .hps, .mp{
    right: 0px;
  }
  .bars{
    align-items: flex-end;
  }
  .ghost_bars{
    right: 90px;
    align-items: flex-end;
  }
  .damage_parameters{
    width: 100%;
    display: flex;
    flex-direction: row-reverse;
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
  .hps, .mp{
    left: 0px;
  }
  .bars{
    align-items: flex-start;
  }
  .ghost_bars{
    left: 90px;
    align-items: flex-start;
  }
  .damage_parameters{
    width: 100%;
  }
}

.fragments{
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  pointer-events: none;
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
  .unclicked{
    &:hover{
      filter: brightness(120%);
      transform: scale(1.05);
    }
  }
  .rewards{
    position: absolute;
    bottom: 150px;
    right: 275px;
    width: 250px;
    border-radius: $radius;
    padding: $thin_space;
    color: $gray3;
    border: 1px solid $plus;
    .reward{
      width: 100%;
      text-align: right;
      .icon, .count{
        display: inline-block;
      }
      .icon{
        width: $font-size-normal;
        height: $font-size-normal;
      }
    }
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
  justify-content: center;
  align-items: center;
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
    line-height: 100%;
    min-width: 6rem;
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
  left: 200px;
  width: 256px;
  height: 256px;
}
.enemy_character{
  position: absolute;
  top: 0;
  right: 180px;
  width: 256px;
  height: 256px;
}
.player_hands{
  position: absolute;
  top: 90px;
  left: $space;
  width: 198px;
  height: 310px;
}
.enemy_hands{
  position: absolute;
  top: 90px;
  right: $space;
  width: 198px;
  height: 310px;
}
.player_selecting_cards{
  position: absolute;
  top: 260px;
  left: 250px;
  width: 198px;
  height: 150px;
}
.enemy_selecting_cards{
  position: absolute;
  top: 260px;
  right: 250px;
  width: 198px;
  height: 150px;
}
.skill_name{
  position: absolute;
  top: 20px;
  left: 0;
  right: 0;
  margin-left: auto;
  margin-right: auto;
  min-width: 150px;
  max-width: 300px;
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
