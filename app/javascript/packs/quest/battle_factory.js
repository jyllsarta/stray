let Battle = require("./battle");
let Player = require("./player");
let Enemy = require("./enemy");

module.exports = class BattleFactory{
    constructor(input) {
        this.player = new Player(input.playerHp, []);
        this.enemy = new Enemy(input.enemyHp, []);
        this.seed = input.seed;
    }

    getBattle(){
        return new Battle(this.player, this.enemy, this.seed);
    }
};
