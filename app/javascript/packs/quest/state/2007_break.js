class OriginalState {
  constructor() {
    this.id = 2007;
    this.ttl = 3;
    this.title = "ブレイク";
    this.icon = "10406.gif";
    this.description = "火ダメージ2倍。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }
}

module.exports = new OriginalState();
