class OriginalState {
  constructor() {
    this.id = 2037;
    this.ttl = -1;
    this.title = "自然回復V";
    this.icon = "1002032.gif";
    this.description = "ターン終了時にHPを5回復。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.addHp(5);
    state.flash();
  }
}

module.exports = new OriginalState();
