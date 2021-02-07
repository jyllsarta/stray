class OriginalState {
  constructor() {
    this.id = 2025;
    this.ttl = -1;
    this.title = "雷陣";
    this.icon = "1004051.gif";
    this.description = "ターン開始時に雷痺カウンター+2。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnStart(state){
    let paralyze = state.owner.findStateById(1004);
    if(!paralyze){
      return;
    }
    paralyze.condition.count += 2;
    paralyze.stateMaster.checkParalyze(paralyze);
    state.flash();
  }
}

module.exports = new OriginalState();
