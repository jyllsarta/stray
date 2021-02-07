class OriginalState {
  constructor() {
    this.id = 2017;
    this.ttl = 1;
    this.title = "落葉";
    this.icon = "1002031.gif";
    this.description = "ターン終了時に1ダメージ。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    state.owner.damage(1);
    state.flash();
  }
}

module.exports = new OriginalState();
