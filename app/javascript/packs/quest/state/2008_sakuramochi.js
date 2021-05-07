class OriginalState {
  constructor() {
    this.id = 2008;
    this.ttl = -1;
    this.title = "超越";
    this.icon = "10408.gif";
    this.description = "ターン開始時に力・技ポイント+5。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnStart(state){
    state.owner.tempBuffs.power += 5;
    state.owner.tempBuffs.tech += 5;
    state.flash();
  }
}

module.exports = new OriginalState();
