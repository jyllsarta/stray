class OriginalState {
  constructor() {
    this.id = 2014;
    this.ttl = 5;
    this.title = "マナブラー";
    this.icon = "20408.gif";
    this.description = "ターン終了時に20MP回復。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    state.owner.addMp(20);
    state.flash();
  }
}

module.exports = new OriginalState();
