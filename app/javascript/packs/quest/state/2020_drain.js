class OriginalState {
  constructor() {
    this.id = 2020;
    this.ttl = -1;
    this.title = "活性化";
    this.icon = "1002051.gif";
    this.description = "ターン終了時に1点HPを吸収。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.addHp(1);
    state.opponent.damage(1);
    state.flash();
  }
}

module.exports = new OriginalState();
