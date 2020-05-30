let SeededRandom = require("./seeded_random");

module.exports = class Battle{
    constructor(player, enemy, history){
        this.player = player;
        this.enemy = enemy;
        this.dice = new SeededRandom(243);
        console.log("loaded!");
    }

    execute(){
        while(!this.isGameEnd()){
            this.player.hp -= this.dice.randInt(0, 50);
            this.enemy.hp -= this.dice.randInt(0, 10);
            console.log("player:" + this.player.hp);
            console.log("enemy:" + this.enemy.hp);
        }
        console.log("isWin:" + (this.player.hp > 0));
    }

    // 以下privateのつもり

    isGameEnd(){
        return !this.player.isAlive() || !this.enemy.isAlive();
    }
};
