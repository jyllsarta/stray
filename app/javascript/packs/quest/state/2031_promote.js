class OriginalState {
  constructor() {
    this.id = 2031;
    this.ttl = 7;
    this.title = "プロモート";
    this.icon = "20401.gif";
    this.description = "ターン終了時に1回復。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    state.owner.addHp(1);
    state.flash();
  }
}

module.exports = new OriginalState();
