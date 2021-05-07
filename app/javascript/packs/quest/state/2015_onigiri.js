class OriginalState {
  constructor() {
    this.id = 2015;
    this.ttl = -1;
    this.title = "生命ノ形";
    this.icon = "30404.gif";
    this.description = "致命的なダメージを受けた時、一度だけHP1で耐える。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onDamage(state, damageAmount){
    if(state.owner.hp <= 0){
      state.owner.hp = 1;
      state.flash();
      this.removeThisState(state);
    }
  }

  removeThisState(state){
    state.owner.states = state.owner.states.filter(s=>s.id!==state.id);
  }
}

module.exports = new OriginalState();
