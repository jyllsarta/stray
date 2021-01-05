class EntityDarkSoul {
  constructor() {
    this.id = 1006;
    this.ttl = -1;
    this.title = "黒熱";
    this.icon = "default.gif";
    this.description = "全ダメージ+1。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onAdd: false,
      onTurnStart: false,
      onTurnEnd: false,
      onDamage: true,
    }
  }

  getInitialCondition(){
    return {
      damageCount: 0,
    };
  }

  showParameter(state){
    return state.condition.damageCount;
  }

  onAdd(state){}
  onTurnStart(state){}
  onDamage(state, damageAmount){
    state.owner.hp -= 1;
  }
  onTurnEnd(state){}
}

module.exports = new EntityDarkSoul();
