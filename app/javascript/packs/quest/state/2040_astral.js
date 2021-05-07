class OriginalState {
  constructor() {
    this.id = 2040;
    this.ttl = -1;
    this.title = "アストラル";
    this.icon = "1008071.gif";
    this.description = "ターン開始時にシールド3と10MPを付与。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnStart(state){
    state.owner.addShield(3);
    state.owner.addMp(10);
    state.flash();
  }
}

module.exports = new OriginalState();
