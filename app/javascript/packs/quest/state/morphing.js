class Morphing {
  constructor() {
    this.id = 2002;
    this.ttl = -1;
    this.title = "変幻";
    this.icon = "morphing.gif";
    this.description = "ターン開始時、力と技の低い方に+10の補正。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnStart(state){
    let SkillResolver = require("../skill_resolver");
    const resolver = new SkillResolver(state.battle);
    resolver.resolveAddPointToWeaker(state.owner, state.opponent, true, 10);
    state.flash();
  }
}

module.exports = new Morphing();
