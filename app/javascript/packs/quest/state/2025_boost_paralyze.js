class OriginalState {
  constructor() {
    this.id = 2025;
    this.ttl = -1;
    this.title = "雷陣";
    this.icon = "1004051.gif";
    this.description = "ターン開始時に雷痺カウンター+2。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }
}

module.exports = new OriginalState();
