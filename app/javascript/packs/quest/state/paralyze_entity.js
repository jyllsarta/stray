class ParalyzeEntity {
  constructor() {
    this.id = 1000;
    this.ttl = -1;
    this.title = "雷痺";
    this.icon = "paralyze.gif";
    this.description = "5回ダメージを受けるとスタンし、そのターン中の力技が0になる。ダメージを受けなかったらターン終了時にカウント-1。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onAdd: false,
      onTurnStart: false,
      onTurnEnd: true,
      onDamage: true,
    }
  }

  getInitialCondition(){
    return {
      count: 0,
      damagedThisTurn: false,
    };
  }

  showParameter(state){
    return state.condition.count;
  }

  onAdd(state){}
  onTurnStart(state){
  }
  onDamage(state, damageAmount){
    state.condition.count += 1;
    state.condition.damagedThisTurn = true;
    if(state.condition.count === 5){
      state.owner.tempBuffs.powerAlterTo = 0;
      state.owner.tempBuffs.techAlterTo = 0;
      state.condition.count = 0;
      state.flash();
      state.battle.flashPalalyzeEffect();
    }
  }
  onTurnEnd(state){
    if(!state.condition.damagedThisTurn && state.condition.count > 0){
      state.condition.count -= 1;
    }
    state.condition.damagedThisTurn =  false;
  }
}

module.exports = new ParalyzeEntity();
