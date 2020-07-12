let BattleFactory = require("./battle_factory");

const input = JSON.parse(process.argv[2]);
const operationHistory = JSON.parse(process.argv[3]);

const battle = new BattleFactory(input).getBattle();

while(!battle.isGameEnd()){
  const oh = operationHistory.shift()
  battle.selectingCardIds = oh.cards;
  battle.selectingSkillId = oh.skill;
  battle.playTurn();
}

console.log(JSON.stringify(battle.outcome()));
