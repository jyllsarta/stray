let SeededRandom = require("./seeded_random");

module.exports = class Battle{
    constructor(player, enemy, seed) {
        this.player = player;
        this.enemy = enemy;
        this.dice = new SeededRandom(seed);
        this.operationHistory = [];
    }

    playTurn(playerChoice){
        this.operationHistory.push(playerChoice);
        this.player.hp -= this.enemy.atk();
        this.enemy.hp -= this.player.deck.findCard(playerChoice).atk();
        this.enemy.draw();
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
