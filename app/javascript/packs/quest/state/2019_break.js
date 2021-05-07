class OriginalState {
  constructor() {
    this.id = 2019;
    this.ttl = -1;
    this.title = "火に弱い";
    this.icon = "1002033.gif";
    this.description = "【火】ダメージを2倍受ける。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }
}

module.exports = new OriginalState();
