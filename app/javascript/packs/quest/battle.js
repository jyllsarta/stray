module.exports = class Battle{
    constructor(player, enemy, history){
        this.player = player;
        this.enemy = enemy;
        console.log("loaded!");
    }

    execute(){
        while(!this.isGameEnd()){
            this.player.hp -= 20;
            this.enemy.hp -= 20;
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
