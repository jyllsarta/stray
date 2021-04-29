class OriginalState {
  constructor() {
    this.id = 2034;
    this.ttl = -1;
    this.title = "創造ノ兎";
    this.icon = "40304.gif";
    this.description = "ターン終了時にHPを2回復。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.addHp(2);
    state.flash();
  }
}

module.exports = new OriginalState();
