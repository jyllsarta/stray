class Poison {
  constructor() {
    this.id = 2003;
    this.ttl = 3;
    this.title = "毒";
    this.icon = "poison.gif";
    this.description = "毒状態。ターン開始時・ダメージ時・ターン終了時に1ダメージを受ける。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnStart(state){
    state.owner.hp -= 1;
    state.flash();
  }
  onDamage(state, damageAmount){
    state.owner.hp -= 1; // onDamage で damage すると無限ループする
    state.flash();
  }
  onTurnEnd(state){
    state.owner.hp -= 1;
    state.flash();
  }
}

module.exports = new Poison();
