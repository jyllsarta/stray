class Regenerate {
  constructor() {
    this.id = 2004;
    this.ttl = 5;
    this.title = "リジェネ";
    this.icon = "regenerate.gif";
    this.description = "リジェネ状態。毎ターン終了時に2回復。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    state.owner.hp += 2;
    state.flash();
  }
}

module.exports = new Regenerate();
