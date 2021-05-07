class EntityFeatherWind {
  constructor() {
    this.id = 1005;
    this.ttl = -1;
    this.title = "翼風";
    this.icon = "feather_wind.gif";
    this.description = "ダメージを与えるたびにMPを10回復。";
  }

  getInitialCondition(){
    return {
      damageCount: 0,
    };
  }

  showParameter(state){
    return "";
  }

  onDamage(state, damageAmount){
    state.opponent.addMp(10);
  }
}

module.exports = new EntityFeatherWind();
