module.exports = class Battle{
    constructor(player, enemy, history){
        this.player = player;
        this.enemy = enemy;
        console.log("loaded!");
    }

    execute(){
        console.log(this.player.hp >= this.enemy.hp);
    }
};
