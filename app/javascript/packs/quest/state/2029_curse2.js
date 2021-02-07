class OriginalState {
  constructor() {
    this.id = 2029;
    this.ttl = -1;
    this.title = "霊縛II";
    this.icon = "1003021.gif";
    this.description = "毎ターン終了時にMP-100。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.damageMp(100);
    state.flash();
  }
}

module.exports = new OriginalState();
