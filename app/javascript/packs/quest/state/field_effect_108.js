class FieldEffect108 {
  constructor() {
    this.id = 108;
    this.ttl = -1;
    this.title = "天祈";
    this.icon = "20408.gif";
    this.description = "初期MP+30。";
  }

  getInitialCondition(){
    return {
    };
  }

  showParameter(state){
    return "-";
  }

  onAdd(state){
    state.battle.player.addMp(30);
    state.battle.enemy.addMp(30);
  }
}

module.exports = new FieldEffect108();
