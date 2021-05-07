class OriginalState {
  constructor() {
    this.id = 2032;
    this.ttl = 3;
    this.title = "プロテク";
    this.icon = "10508.gif";
    this.description = "ターン開始時に5点分のシールドを張る。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnStart(state){
    state.owner.addShield(5);
    state.flash();
  }
}

module.exports = new OriginalState();
