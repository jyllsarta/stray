class OriginalState {
  constructor() {
    this.id = 2035;
    this.ttl = -1;
    this.title = "転生ノ水";
    this.icon = "40408.gif";
    this.description = "致命的なダメージを受けた時、一度だけHP全快で耐える。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onDamage(state, damageAmount){
    if(state.owner.hp <= 0){
      state.owner.hp = state.owner.hp_max;
      state.flash();
      this.removeThisState(state);
    }
  }

  removeThisState(state){
    state.owner.states = state.owner.states.filter(s=>s.id!==state.id);
  }
}

module.exports = new OriginalState();
