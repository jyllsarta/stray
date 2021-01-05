class FieldEffectWoodRegenerate {
  constructor() {
    this.id = 102;
    this.ttl = -1;
    this.title = "翠癒";
    this.icon = "default.gif";
    this.description = "ダメージを受けなかったターンの終了時、HPを1回復する。";
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
    const stateId = 1002;
    state.battle.addState(true, stateId);
    state.battle.addState(false, stateId);
  }
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){}
}

module.exports = new FieldEffectWoodRegenerate();
