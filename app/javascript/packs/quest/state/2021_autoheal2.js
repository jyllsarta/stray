class OriginalState {
  constructor() {
    this.id = 2021;
    this.ttl = -1;
    this.title = "自然回復II";
    this.icon = "1002032.gif";
    this.description = "ターン終了時にHPを2回復。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.addHp(2);
    state.flash();
  }
}

module.exports = new OriginalState();
