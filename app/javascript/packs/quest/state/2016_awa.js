class OriginalState {
  constructor() {
    this.id = 2016;
    this.ttl = -1;
    this.title = "封泡減力";
    this.icon = "1001052.gif";
    this.description = "ダメージを受けるたび、MP-10。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onDamage(state, damageAmount){
    state.owner.damageMp(10);
    state.flash();
  }
}

module.exports = new OriginalState();
