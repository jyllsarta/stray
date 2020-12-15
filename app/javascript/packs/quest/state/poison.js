class Poison {
  constructor() {
    this.id = 1;
    this.icon = "default.png";
    this.guideMessage = "毒状態。毎ターン終了時に1ダメージを受ける。";
  }

  onAdd(state){}
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){
    state.owner.hp -= 1;
  }
};

module.exports = new Poison();
