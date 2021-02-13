class OriginalState {
  constructor() {
    this.id = 2009;
    this.ttl = 3;
    this.title = "フォーリン";
    this.icon = "20205.gif";
    this.description = "ターン終了時に3ダメージ。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    state.owner.damage(3);
    state.flash();
  }
}

module.exports = new OriginalState();
