class FieldEffectParalyze {
  constructor() {
    this.id = 104;
    this.ttl = -1;
    this.title = "雷痺";
    this.icon = "paralyze.gif";
    this.description = "5回ダメージを受けるとスタンし、そのターン中の力技が0になる。ダメージを受けなかったらターン終了時にカウント-1。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onAdd: true,
      onTurnStart: false,
      onTurnEnd: false,
      onDamage: false,
    }
  }

  getInitialCondition(){
    return {
    };
  }

  showParameter(state){
    return state.ttl;
  }

  onAdd(state){
    const stateId = 1004;
    state.battle.addState(true, stateId);
    state.battle.addState(false, stateId);
  }
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){}
}

module.exports = new FieldEffectParalyze();
