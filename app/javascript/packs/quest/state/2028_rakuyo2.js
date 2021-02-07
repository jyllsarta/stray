class OriginalState {
  constructor() {
    this.id = 2028;
    this.ttl = 1;
    this.title = "落葉II";
    this.icon = "1002031.gif";
    this.description = "ターン終了時に2ダメージ。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    state.owner.damage(2);
    state.flash();
  }
}

module.exports = new OriginalState();
