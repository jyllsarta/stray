class FieldEffectMagicStream {
  constructor() {
    this.id = 107;
    this.ttl = -1;
    this.title = "魔濁";
    this.icon = "default.gif";
    this.description = "ターン終了時にMP+20。";
  }

  getInitialCondition(){
    return {
    };
  }

  showParameter(state){
    return state.ttl;
  }

  onAdd(state){
    const stateId = 1007;
    state.battle.addState(true, stateId);
    state.battle.addState(false, stateId);
  }
}

module.exports = new FieldEffectMagicStream();