let SeededRandom = require("./seeded_random");

module.exports = class Battle{
    constructor(player, enemy, history){
        this.player = player;
        this.enemy = enemy;
        this.dice = new SeededRandom(243);
    }

    execute(){
        while(!this.isGameEnd()){
            this.player.hp -= this.dice.randInt(0, 50);
            this.enemy.hp -= this.dice.randInt(0, 10);
        }
    }

    outcome(){
        return {
            isWin: this.isWin(),
            isDraw: this.isDraw(),
        }
    }

    // 以下privateのつもり

    // 生存して相手が死んでれば勝ち
    isWin(){
        return this.player.isAlive() && !this.enemy.isAlive();
    }

    // 両方死んでれば引き分け
    isDraw(){
        return !this.player.isAlive() && !this.enemy.isAlive();
    }

    isGameEnd(){
        return !this.player.isAlive() || !this.enemy.isAlive();
    }
};
