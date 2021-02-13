class EntityParalyze {
  constructor() {
    this.id = 1004;
    this.ttl = -1;
    this.title = "雷痺";
    this.icon = "paralyze.gif";
    this.description = "5回ダメージを受けるとスタンし、そのターン中の力技が0になる。ダメージを受けなかったらターン終了時にカウント-1。";
  }

  getInitialCondition(){
    return {
      count: 0,
      damagedThisTurn: false,
      paralyzedThisTurn: false,
    };
  }

  showParameter(state){
    return state.condition.count;
  }

  onDamage(state, damageAmount){
    if(state.condition.paralyzedThisTurn){
      return;
    }
    state.condition.count += 1;
    state.condition.damagedThisTurn = true;
    this.checkParalyze(state);
  }
  onTurnEnd(state){
    if(!state.condition.damagedThisTurn && state.condition.count > 0){
      state.condition.count -= 1;
    }
    state.condition.damagedThisTurn =  false;
    state.condition.paralyzedThisTurn =  false;
  }

  checkParalyze(state){
    if(state.condition.count >= 5){
      state.owner.tempBuffs.powerAlterTo = 0;
      state.owner.tempBuffs.techAlterTo = 0;
      state.condition.count = 0;
      state.flash();
      state.battle.flashPalalyzeEffect();
      state.condition.paralyzedThisTurn = true;
    }
  }
}

module.exports = new EntityParalyze();
