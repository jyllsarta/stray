class OriginalState {
  constructor() {
    this.id = 2015;
    this.ttl = -1;
    this.title = "生命ノ形";
    this.icon = "30404.gif";
    this.description = "致命的なダメージを受けた時、一度だけHP3で耐える。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onDamage(state, damageAmount){
    // onDamage が「ダメージに際し」呼ばれるコールバックなので、実際にダメージが引かれるのはonDamageの解決後。死にそうなら死なない感じに回復する。
    console.log(state.owner.hp);
    if((state.owner.hp - damageAmount) <= 0){
      state.owner.hp = 3 + damageAmount;
      state.flash();
      this.removeThisState(state);
    }
  }

  removeThisState(state){
    state.owner.states = state.owner.states.filter(s=>s.id!==state.id);
  }
}

module.exports = new OriginalState();
