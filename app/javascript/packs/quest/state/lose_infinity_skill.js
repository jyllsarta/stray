class LoseInfinitySkill {
  constructor() {
    this.id = 2001;
    this.ttl = 1;
    this.title = "カラミティ";
    this.icon = "lose_infinity_skill.gif";
    this.description = "ターン終了時、全スキルが∞を失う。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnEnd(state){
    for(let skill of state.owner.skills){
      skill.reusable = false;
    }
  }
}

module.exports = new LoseInfinitySkill();
