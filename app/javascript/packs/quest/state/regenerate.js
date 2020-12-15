class Regenerate {
  constructor() {
    this.id = 2;
    this.icon = "default.png";
    this.guideMessage = "リジェネ状態。毎ターン終了時に2回復。";
  }

  onAdd(state){}
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){
    state.owner.hp += 2;
  }
};

module.exports = new Regenerate();
