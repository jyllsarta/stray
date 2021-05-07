class OriginalState {
  constructor() {
    this.id = 2018;
    this.ttl = -1;
    this.title = "自然回復I";
    this.icon = "1002032.gif";
    this.description = "ターン終了時にHPを1回復。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnEnd(state){
    state.owner.addHp(1);
    state.flash();
  }
}

module.exports = new OriginalState();
