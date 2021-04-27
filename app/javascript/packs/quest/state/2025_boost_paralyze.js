class OriginalState {
  constructor() {
    this.id = 2025;
    this.ttl = -1;
    this.title = "雷陣";
    this.icon = "1004051.gif";
    this.description = "ターン開始時に1ダメージ。(スキル使用前に発動)";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onTurnStart(state){
    state.owner.damage(1);
    state.flash();
  }
}

module.exports = new OriginalState();
