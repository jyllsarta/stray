class OriginalState {
  constructor() {
    this.id = 2026;
    this.ttl = -1;
    this.title = "崩壊II";
    this.icon = "1003041.gif";
    this.description = "毎ターン終了時に自身に6ダメージ。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.damage(6);
    state.flash();
  }
}

module.exports = new OriginalState();
