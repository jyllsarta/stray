let BattleFactory = require("./battle_factory");

const input = JSON.parse(process.argv[2]);
const operationHistory = JSON.parse(process.argv[3]);

const battle = new BattleFactory(input).getBattle();

while(!battle.isGameEnd()){
  battle.selectingCardIds = operationHistory.shift();
  battle.playTurn();
}

console.log(JSON.stringify(battle.outcome()));
