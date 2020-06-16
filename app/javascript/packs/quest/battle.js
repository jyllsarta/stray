let SeededRandom = require("./seeded_random");

module.exports = class Battle{
    constructor(player, enemy, seed) {
        this.seed = seed;
        this.dice = new SeededRandom(seed);
        this.player = player;
        this.enemy = enemy;

        // デッキ回りの初期化はバトルがやるの違うのかもなと思いつつも、一旦ここ意外に役割を持たせるとそれはそれで歪むので別の需要が出てくるまで待つ
        this.player.deck.setSeededDice(this.dice);
        this.enemy.deck.setSeededDice(this.dice);

        this.player.deck.shuffle();
        this.enemy.deck.shuffle();

        this.player.deck.fillDraw();
        this.enemy.deck.fillDraw();

        this.operationHistory = [];
        this.selectingCardIds = [];
        this.enemyCardIds = [];

        this.battleLog = [];

        this.pickEnemyCards();
    }

    selectCard(cardId){
        if(this.selectingCardIds.includes(cardId)){
            this.selectingCardIds = this.selectingCardIds.filter(n => n !== cardId);
        }
        else{
            this.selectingCardIds.push(cardId);
        }
    }

    playTurn(){
        this.validateSelectingCardIds();
        this.operationHistory.push(this.selectingCardIds);

        const powerMeetResult = this.powerMeetResult();
        const techMeetResult = this.techMeetResult();

        const winCount = [powerMeetResult, techMeetResult].filter((x)=>x==="win").length;
        const drawCount = [powerMeetResult, techMeetResult].filter((x)=>x==="draw").length;

        // ここどう書くとわかりやすくなるかなあ
        if(winCount === 2){
            this.player.hp -= 0;
            this.enemy.hp -= 3;
        }
        if(winCount === 1 && drawCount === 1){
            this.player.hp -= 0;
            this.enemy.hp -= 1;
        }
        if(winCount === 1 && drawCount === 0){
            this.player.hp -= 1;
            this.enemy.hp -= 1;
        }
        if(winCount === 0 && drawCount === 1){
            this.player.hp -= 1;
            this.enemy.hp -= 0;
        }
        if(winCount === 0 && drawCount === 0){
            this.player.hp -= 3;
            this.enemy.hp -= 0;
        }

        this.battleLog.push([powerMeetResult, techMeetResult]);

        this.player.deck.consumeCards(this.selectingCardIds);
        this.enemy.deck.consumeCards(this.enemyCardIds);
        this.selectingCardIds = [];
        this.player.deck.fillDraw();

        this.enemyCardIds = [];
        this.enemy.deck.fillDraw();
        this.pickEnemyCards();
    }

    outcome(){
        return {
            isWin: this.isWin(),
            isDraw: this.isDraw(),
            log: this.battleLog,
            seed: this.seed,
        }
    }

    // 以下privateのつもり

    pickEnemyCards(){
        this.enemyCardIds = this.enemy.deck.handCardIds.slice(0, 3);
    }

    validateSelectingCardIds(){
        const uniqueCardIds = this.selectingCardIds.filter((elem, index, self) => self.indexOf(elem) === index);
        if(uniqueCardIds.length !== 3){
            console.error("selecting cards number is not exactly three");
        }
        if(!uniqueCardIds.every((x)=>this.player.deck.handCardIds)){
            console.error("using hand that player do not have");
        }
    }

    powerMeetResult(category){
        if(this.player.powerAt(this.selectingCardIds) > this.enemy.powerAt(this.enemyCardIds)){
            return "win";
        }
        if(this.player.powerAt(this.selectingCardIds) < this.enemy.powerAt(this.enemyCardIds)){
            return "lose";
        }
        return "draw";
    }

    techMeetResult(category){
        if(this.player.techAt(this.selectingCardIds) > this.enemy.techAt(this.enemyCardIds)){
            return "win";
        }
        if(this.player.techAt(this.selectingCardIds) < this.enemy.techAt(this.enemyCardIds)){
            return "lose";
        }
        return "draw";
    }

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
