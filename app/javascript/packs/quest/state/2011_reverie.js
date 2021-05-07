class OriginalState {
  constructor() {
    this.id = 2011;
    this.ttl = 2;
    this.title = "レヴァリエ";
    this.icon = "20210.gif";
    this.description = "次のターン終了時に17ダメージ。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    if(state.ttl === 1){
      state.owner.damage(17);
      state.flash();  
    }
  }
}

module.exports = new OriginalState();
