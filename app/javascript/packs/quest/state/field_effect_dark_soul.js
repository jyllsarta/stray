class FieldEffectDarkSoul {
  constructor() {
    this.id = 106;
    this.ttl = -1;
    this.title = "黒熱";
    this.icon = "default.gif";
    this.description = "全ダメージ+1。";
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
}

module.exports = new FieldEffectDarkSoul();
