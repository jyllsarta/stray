class OriginalState {
  constructor() {
    this.id = 2027;
    this.ttl = -1;
    this.title = "自然回復III";
    this.icon = "1002032.gif";
    this.description = "ターン終了時にHPを3回復。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.addHp(3);
    state.flash();
  }
}

module.exports = new OriginalState();
