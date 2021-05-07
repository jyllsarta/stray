class OriginalState {
  constructor() {
    this.id = 2033;
    this.ttl = 5;
    this.title = "シーズ";
    this.icon = "20508.gif";
    this.description = "毎ターン終了時にMP-10。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    state.owner.damageMp(10);
    state.flash();
  }
}

module.exports = new OriginalState();
