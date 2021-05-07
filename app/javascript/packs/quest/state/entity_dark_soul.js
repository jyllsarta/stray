class EntityDarkSoul {
  constructor() {
    this.id = 1006;
    this.ttl = -1;
    this.title = "黒熱";
    this.icon = "dark_soul.gif";
    this.description = "全ダメージ+1。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "";
  }

  onDamage(state, damageAmount){
    state.owner.hp -= 1;
  }
}

module.exports = new EntityDarkSoul();
