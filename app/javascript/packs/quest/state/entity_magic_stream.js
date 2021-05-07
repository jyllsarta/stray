class EntitymagicStream {
  constructor() {
    this.id = 1007;
    this.ttl = -1;
    this.title = "霊流";
    this.icon = "magic_stream.gif";
    this.description = "ターン終了時にMP+20。";
  }

  getInitialCondition(){
    return {
      damageCount: 0,
    };
  }

  showParameter(state){
    return ""; //バグったらごめんって感じ
  }

  onTurnEnd(state){
    state.owner.addMp(20);
  }
}

module.exports = new EntitymagicStream();
