class EntityDarkSoul {
  constructor() {
    this.id = 1006;
    this.ttl = -1;
    this.title = "黒熱";
    this.icon = "default.gif";
    this.description = "全ダメージ+1。";
  }

  getInitialCondition(){
    return {
      damageCount: 0,
    };
  }

  showParameter(state){
    return state.condition.damageCount;
  }

  onDamage(state, damageAmount){
    state.owner.hp -= 1;
  }
}

module.exports = new EntityDarkSoul();
