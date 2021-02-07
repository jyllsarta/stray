class OriginalState {
  constructor() {
    this.id = 2023;
    this.ttl = -1;
    this.title = "崩壊I";
    this.icon = "1003041.gif";
    this.description = "毎ターン終了時に自身に4ダメージ。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.damage(4);
    state.flash();
  }
}

module.exports = new OriginalState();
