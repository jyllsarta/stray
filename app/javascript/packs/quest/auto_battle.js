let BattleFactory = require("./battle_factory");

const input = JSON.parse(process.argv[2]);

const battle = new BattleFactory(input).getBattle();

battle.execute();

console.log(JSON.stringify(battle.outcome()));
