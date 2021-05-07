class OriginalState {
  constructor() {
    this.id = 2005;
    this.ttl = 2;
    this.title = "クランプル";
    this.icon = "10206.gif";
    this.description = "次のターンの終わりまで全ダメージ+1。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onDamage(state, damageAmount){
    state.owner.hp -= 1;
    state.flash();
  }
}

module.exports = new OriginalState();
