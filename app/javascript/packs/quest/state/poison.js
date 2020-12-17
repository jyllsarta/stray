class Poison {
  constructor() {
    this.id = 1;
    this.ttl = 3;
    this.icon = "poison.gif";
    this.description = "毒状態。ターン開始時・ダメージ時・ターン終了時に1ダメージを受ける。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onTurnStart: true,
      onTurnEnd: true,
      onDamage: true,
    }
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnStart(state){
    state.owner.hp -= 1;
  }
  onDamage(state, damageAmount){
    state.owner.hp -= 1;
  }
  onTurnEnd(state){
    state.owner.hp -= 1;
  }
}

module.exports = new Poison();
