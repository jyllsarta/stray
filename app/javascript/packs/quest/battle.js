let SeededRandom = require("./seeded_random");
let SkillResolver = require("./skill_resolver");

module.exports = class Battle{
    constructor(player, enemy, seed) {
        this.seed = seed;
        this.dice = new SeededRandom(seed);
        this.skillResolver = new SkillResolver(this);
        this.player = player;
        this.enemy = enemy;

        this.turnInProgress = false;
        this.turnStatus = "selectCard";

        this.resetCharacterStatus();

        // デッキ回りの初期化はバトルがやるの違うのかもなと思いつつも、一旦ここ意外に役割を持たせるとそれはそれで歪むので別の需要が出てくるまで待つ
        this.player.deck.setSeededDice(this.dice);
        this.enemy.deck.setSeededDice(this.dice);

        this.player.deck.shuffle();
        this.enemy.deck.shuffle();

        this.player.deck.fillDraw(this.player.totalHandCardCount());
        this.enemy.deck.fillDraw(this.enemy.totalHandCardCount());

        this.operationHistory = [];
        this.enemyOperationHistory = [];
        this.selectingCardIds = [];
        this.enemyCardIds = [];

        this.battleLog = [];

        this.pickEnemyCards();
        this.pickEnemySkill();
    }

    selectCard(cardId){
        if(this.turnInProgress){
            return;
        }
        if(this.selectingCardIds.includes(cardId)){
            this.selectingCardIds = this.selectingCardIds.filter(n => n !== cardId);
            return;
        }
        if(this.selectingCardIds.length === 3){
            return;
        }
        this.selectingCardIds.push(cardId);
    }

    selectSkill(skillIndex){
        if(this.turnInProgress){
            return;
        }
        if(!this.canUseSkill(skillIndex)){
            return;
        }
        if(this.player.selectingSkillIndex === skillIndex){
            this.player.selectingSkillIndex = null;
            return;
        }
        this.player.selectingSkillIndex = skillIndex;
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
        this.turnStatus = "playerMagic";
        const skillIndex = this.player.selectingSkillIndex;
        if(skillIndex === null || skillIndex === undefined){
            return;
        }
        if(!this.canUseSkill(skillIndex)){
            console.warn(`不正なスキル指定です！ idx:${skillIndex}`);
            return;
        }
        const skill = this.player.selectingSkill();
        const effects = skill.effects;
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(true,  effect.category, effect.to_self, effect.value, skill.is_defence);
        }
        this.player.useMp(skill.cost);
        this.characterStatus.tirol = 'magic';
    }

    invokeEnemyMagic(){
        this.turnStatus = "enemyMagic";
        this.resetCharacterStatus();
        const skillIndex = this.enemy.selectingSkillIndex;
        if(skillIndex === null || skillIndex === undefined){
            return;
        }
        if(!this.canEnemyUseSkill(skillIndex)){
            // damageMpにより、使おうと思ったスキルをすかされる可能性が出たのでワーニングは表示しない
            return;
        }
        const skill = this.enemy.selectingSkill();
        const effects = skill.effects;
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(false,  effect.category, effect.to_self, effect.value, skill.is_defence);
        }
        this.enemy.useMp(skill.cost);
        this.characterStatus.enemy = 'magic';
        this.characterStatus.tirol = 'normal';
    }

    invokePowerAttack(){
        this.turnStatus = "powerAttack";
        const result = this.powerMeetResult();
        if(result === "win"){
            this.enemy.damage(this.player.damageAt("power"));
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.characterStatus.spica = 'attack';
            this.characterStatus.enemy = 'lose';
        }
        else if(result === "lose"){
            this.player.damage(this.enemy.damageAt("power"));
            this.player.addMp(10);
            this.enemy.addMp(5);
            this.characterStatus.spica = 'lose';
            this.characterStatus.enemy = 'attack';
        }
        else{
            this.player.addMp(20);
            this.enemy.addMp(0);
            this.characterStatus.spica = 'draw';
            this.characterStatus.enemy = 'draw';
        }
        this.characterStatus.tirol = 'normal';
    }

    invokeTechAttack(){
        this.turnStatus = "techAttack";
        const result = this.techMeetResult();
        if(result === "win"){
            this.enemy.damage(this.player.damageAt("tech"));
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.characterStatus.spica = 'attack2';
            this.characterStatus.enemy = 'lose';

        }
        else if(result === "lose"){
            this.player.damage(this.enemy.damageAt("tech"));
            this.player.addMp(10);
            this.enemy.addMp(5);
            this.characterStatus.spica = 'lose';
            this.characterStatus.enemy = 'attack';
        }
        else{
            this.player.addMp(20);
            this.enemy.addMp(0);
            this.characterStatus.spica = 'draw';
            this.characterStatus.enemy = 'draw';
        }
    }

    invokeSPAttack(){
        this.turnStatus = "SPAttack";
        const powerResult = this.powerMeetResult();
        const techResult = this.techMeetResult();
        if(powerResult === "win" && techResult === "win"){
            this.enemy.damage(this.player.damageAt("special"));
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.characterStatus.spica = 'attack3';
            this.characterStatus.enemy = 'lose';
        }
        else if(powerResult === "lose" && techResult === "lose"){
            this.player.damage(this.enemy.damageAt("special"));
            this.player.addMp(10);
            this.enemy.addMp(5);
            this.characterStatus.spica = 'lose';
            this.characterStatus.enemy = 'attack';
        }
        else{
            // nop
        }
    }

    isSPAttackWillHappen(){
        const powerResult = this.powerMeetResult();
        const techResult = this.techMeetResult();
        return (powerResult === "win" && techResult === "win") || (powerResult === "lose" && techResult === "lose");
    }

    onTurnEnd(){
        this.resetCharacterStatus();
        this.battleLog.push([this.powerMeetResult(), this.techMeetResult()]);
        this.operationHistory.push({cards: this.selectingCardIds, skillIndex: this.player.selectingSkillIndex});
        this.enemyOperationHistory.push({cards: this.enemyCardIds, skillIndex: this.enemy.selectingSkillIndex});

        this.player.deck.consumeCards(this.selectingCardIds);
        this.enemy.deck.consumeCards(this.enemyCardIds);
        this.selectingCardIds = [];
        this.player.selectingSkillIndex = null;
        this.player.deck.fillDraw(this.player.totalHandCardCount());

        this.enemyCardIds = [];
        this.enemy.selectingSkillIndex = null;
        this.enemy.deck.fillDraw(this.enemy.totalHandCardCount());
        this.pickEnemyCards();
        this.pickEnemySkill();

        this.player.resetTempBuffs();
        this.enemy.resetTempBuffs();
        this.turnInProgress = false;
        this.turnStatus = "selectCard";
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

    phaseIndex(){
        return ["selectCard", "playerMagic", "enemyMagic", "powerAttack", "techAttack", "SPAttack"].indexOf(this.turnStatus);
    }

    // こうして条件を書いていくと operationHistory は character の持つべきロジックだった感がある
    canUseSkill(skillIndex){
        const skill = this.player.skills[skillIndex];
        if(!skill){
            return false;
        }
        // MPが足りてないとダメ
        if (this.player.mp < (skill.cost) ){
            return false;
        }
        // reusable = false のスキルは一回使ってたらダメ
        if ( !skill.reusable && this.operationHistory.map((x)=>x.skillIndex).includes(skillIndex)){
            return false;
        }
        return true;
    }

    canEnemyUseSkill(skillIndex){
        const skill = this.enemy.skills[skillIndex];
        if(!skill){
            return false;
        }
        // MPが足りてないとダメ
        if (this.enemy.mp < (skill.cost) ){
            return false;
        }
        // reusable = false のスキルは一回使ってたらダメ
        if ( !skill.reusable && this.enemyOperationHistory.map((x)=>x.skillIndex).includes(skillIndex)){
            return false;
        }
        return true;
    }

    onTurnStart(){
        this.turnInProgress = true;
        this.validateSelectingCardIds();
    }

    pickEnemyCards(){
        this.enemyCardIds = this.enemy.deck.handCardIds.slice(0, 3);
    }

    pickEnemySkill(){
        for(let i=0; i<this.enemy.skills.length; i++){
            if(this.canEnemyUseSkill(i)){
                this.enemy.selectingSkillIndex = i;
                return;
            }
        }
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

    resetCharacterStatus(){
        this.characterStatus = {
            spica: 'normal',
            tirol: 'normal',
            enemy: 'normal',
        };
    }
};
