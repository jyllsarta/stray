let BattleFactory = require("./battle_factory");

const input = JSON.parse(process.argv[2]);
const operationHistory = JSON.parse(process.argv[3]);

const battle = new BattleFactory(input).getBattle();

while(!battle.isGameEnd()){
  const oh = operationHistory.shift()
  battle.selectingCardIds = oh.cards;
  battle.player.selectingSkillIndexes = oh.skillIndex;
  battle.playTurn();
}

console.log(JSON.stringify(battle.outcome()));
