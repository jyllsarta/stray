class OriginalState {
  constructor() {
    this.id = 2022;
    this.ttl = -1;
    this.title = "霊縛";
    this.icon = "1003021.gif";
    this.description = "毎ターン終了時にMP-15。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.damageMp(15);
    state.flash();
  }
}

module.exports = new OriginalState();
