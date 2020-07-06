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
            return;
        }
        if(this.selectingCardIds.length === 3){
            return;
        }
        this.selectingCardIds.push(cardId);
    }

    playTurn(){
        this.onTurnStart();
        this.invokePlayerMagic();
        this.invokeEnemyMagic();
        this.invokePowerAttack();
        this.invokeTechAttack();
        this.invokeSPAttack();
        this.onTurnEnd();
    }

    invokePlayerMagic(){
        // 魔法実装したら魔法のExecuteがはいる
    }

    invokeEnemyMagic(){
        // 魔法実装したら魔法のExecuteがはいる
    }

    invokePowerAttack(){
        const result = this.powerMeetResult();
        if(result === "win"){
            this.enemy.hp -= 1;
        }
        else if(result === "lose"){
            this.player.hp -= 1;
        }
        else{
            // nop
        }
    }

    invokeTechAttack(){
        const result = this.techMeetResult();
        if(result === "win"){
            this.enemy.hp -= 1;
        }
        else if(result === "lose"){
            this.player.hp -= 1;
        }
        else{
            // nop
        }
    }

    invokeSPAttack(){
        const powerResult = this.powerMeetResult();
        const techResult = this.techMeetResult();
        if(powerResult === "win" && techResult === "win"){
            this.enemy.hp -= 1;
        }
        else if(powerResult === "lose" && techResult === "lose"){
            this.player.hp -= 1;
        }
        else{
            // nop
        }
    }

    onTurnEnd(){
        this.battleLog.push([this.powerMeetResult(), this.techMeetResult()]);

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

    onTurnStart(){
        this.validateSelectingCardIds();
        this.operationHistory.push(this.selectingCardIds);
    }

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
