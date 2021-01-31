class OriginalState {
  constructor() {
    this.id = 2006;
    this.ttl = 1;
    this.title = "ツインズ";
    this.icon = "10207.gif";
    this.description = "ターン終了時に2ダメージ。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    state.owner.hp -= 2;
    state.flash();
  }
}

module.exports = new OriginalState();
