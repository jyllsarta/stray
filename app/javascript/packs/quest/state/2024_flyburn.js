class OriginalState {
  constructor() {
    this.id = 2024;
    this.ttl = -1;
    this.title = "逆巻く炎";
    this.icon = "1003051.gif";
    this.description = "ターン開始時に1ダメージ。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnStart(state){
    state.owner.damage(1);
    state.flash();
  }
}

module.exports = new OriginalState();
