class FieldEffectDarkSoul {
  constructor() {
    this.id = 106;
    this.ttl = -1;
    this.title = "黒熱";
    this.icon = "default.gif";
    this.description = "全ダメージ+1。";
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
    return "-";
  }

  onAdd(state){
    const stateId = 1006;
    state.battle.addState(true, stateId);
    state.battle.addState(false, stateId);
  }
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){}
}

module.exports = new FieldEffectDarkSoul();
