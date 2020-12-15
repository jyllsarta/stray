module.exports = class StateInstance {
  constructor(stateId, stateMaster, battle, owner, opponent) {
    this.stateId = stateId;
    this.stateMaster = stateMaster;
    this.battle = battle;
    this.owner = owner;
    this.opponent = opponent;
    this.ttl = this.stateMaster.ttl;
    this.condition = this.stateMaster.getInitialCondition();
  }
};
