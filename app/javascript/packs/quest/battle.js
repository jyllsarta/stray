let SeededRandom = require("./seeded_random");
let SkillResolver = require("./skill_resolver");

module.exports = class Battle{
    constructor(player, enemy, seed) {
        this.seed = seed;
        this.dice = new SeededRandom(seed);
        this.skillResolver = new SkillResolver(this);
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
        this.selectingSkillId = null;
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

    selectSkill(skillId){
        if(!this.canUseSkill(skillId)){
            return;
        }
        if(this.selectingSkillId === skillId){
            this.selectingSkillId = null;
            return;
        }
        this.selectingSkillId = skillId;
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
        if(this.selectingSkillId === null){
            return;
        }
        if(!this.canUseSkill(this.selectingSkillId)){
            console.warn(`不正なスキル指定です！${this.selectingSkillId}`)
        }
        const effects = this.player.skills.find((x)=>x.id===this.selectingSkillId).effects;
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(true,  effect.category, effect.to_self, effect.value);
        }
    }

    invokeEnemyMagic(){
        // 魔法実装したら魔法のExecuteがはいる
    }

    invokePowerAttack(){
        const result = this.powerMeetResult();
        if(result === "win"){
            this.enemy.hp -= 1;
            this.player.addMp(5);
            this.enemy.addMp(10);
        }
        else if(result === "lose"){
            this.player.hp -= 1;
            this.player.addMp(10);
            this.enemy.addMp(5);
        }
        else{
            this.player.addMp(40);
            this.enemy.addMp(0);
        }
    }

    invokeTechAttack(){
        const result = this.techMeetResult();
        if(result === "win"){
            this.enemy.hp -= 1;
            this.player.addMp(5);
            this.enemy.addMp(10);
        }
        else if(result === "lose"){
            this.player.hp -= 1;
            this.player.addMp(10);
            this.enemy.addMp(5);
        }
        else{
            this.player.addMp(40);
            this.enemy.addMp(0);
        }
    }

    invokeSPAttack(){
        const powerResult = this.powerMeetResult();
        const techResult = this.techMeetResult();
        if(powerResult === "win" && techResult === "win"){
            this.enemy.hp -= 1;
            this.player.addMp(0);
            this.enemy.addMp(20);
        }
        else if(powerResult === "lose" && techResult === "lose"){
            this.player.hp -= 1;
            this.player.addMp(20);
            this.enemy.addMp(0);
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
        this.selectingSkillId = null;
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

    canUseSkill(skillId){
        const skill = this.player.skills.find((x)=>x.id===skillId);
        // MPが足りてないとダメ
        if (this.player.mp < skill.cost ){
            return false;
        }
        // reusable = false のスキルは一回使ってたらダメ
        if ( !skill.reusable && this.operationHistory.map((x)=>x.skill).includes(skillId)){
            return false;
        }
        return true;
    }

    onTurnStart(){
        this.validateSelectingCardIds();
        this.operationHistory.push({cards: this.selectingCardIds, skill: this.selectingSkillId});
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
