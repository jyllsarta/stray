let SeededRandom = require("./seeded_random");
let SkillResolver = require("./skill_resolver");
let StateLibrary = require("./state_library");
let StateInstance = require("./state_instance");

module.exports = class Battle{
    constructor(player, enemy, seed) {
        this.seed = seed;
        this.dice = new SeededRandom(seed);
        this.skillResolver = new SkillResolver(this);
        this.player = player;
        this.enemy = enemy;

        this.turnInProgress = false;
        this.turnStatus = "selectCard";

        this.setCharacterStatusAll("waiting");
        this.lastAttackResult = "";

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

        this.stateLibrary = new StateLibrary();
    }

    selectCard(cardId){
        if(this.turnInProgress){
            return;
        }
        if(this.selectingCardIds.includes(cardId)){
            this.selectingCardIds = this.selectingCardIds.filter(n => n !== cardId);
            return;
        }
        if(this.selectingCardIds.length === 2){
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

        // 消すのは予算判定しなくてOK
        if(this.player.selectingSkillIndexes.includes(skillIndex)){
            this.player.removeSKillBySkillIndex(skillIndex);
            return;
        }

        //スキルを積む場合は予算判定を通っていないとダメ
        const consumeMp = this.player.consumingMp() + this.player.skills[skillIndex].cost;
        if(this.player.mp < consumeMp){
            return;
        }

        this.player.selectingSkillIndexes.push(skillIndex);
    }

    playTurn(){
        this.onTurnStart();
        for(let i of this.player.selectingSkillIndexes){
            this.invokePlayerMagic(i);
        }
        if( this.isGameEnd() ){ this.onTurnEnd(); return; } // クライアントと同じタイミングで短絡終了する
        for(let i of this.enemy.selectingSkillIndexes){
            this.invokeEnemyMagic(i);
        }
        if( this.isGameEnd() ){ this.onTurnEnd(); return; } // クライアントと同じタイミングで短絡終了する
        this.invokePowerAttack();
        this.invokeTechAttack();
        this.invokeSPAttack();
        this.onTurnEnd();
    }

    invokePlayerMagicStart(){
        this.turnStatus = "playerMagic";
    }

    invokePlayerMagic(skillIndex){
        if(!this.canUseSkill(skillIndex)){
            console.warn(`不正なスキル指定です！ idx:${skillIndex}`);
            return;
        }
        const skill = this.player.skills[skillIndex];
        const effects = skill.effects;
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(true,  effect.category, effect.to_self, effect.value, skill.is_defence);
        }
        this.player.useMp(skill.cost);
        this.characterStatus.tirol = 'magic';
    }

    invokeEnemyMagicStart(){
        this.turnStatus = "enemyMagic";
    }

    invokeEnemyMagic(skillIndex){
        if(!this.canEnemyUseSkill(skillIndex)){
            // damageMpにより、使おうと思ったスキルをすかされる可能性が出たのでワーニングは表示しない
            return;
        }
        const skill = this.enemy.skills[skillIndex];
        const effects = skill.effects;
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(false,  effect.category, effect.to_self, effect.value, skill.is_defence);
        }
        this.enemy.useMp(skill.cost);
        this.characterStatus.enemy = 'magic';
    }

    invokePowerAttack(){
        this.turnStatus = "powerAttack";
        const result = this.powerMeetResult();
        this.lastAttackResult = result;
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
        this.lastAttackResult = result;
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
            this.lastAttackResult = "win";
            this.enemy.damage(this.player.damageAt("special"));
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.characterStatus.spica = 'attack3';
            this.characterStatus.enemy = 'lose';
        }
        else if(powerResult === "lose" && techResult === "lose"){
            this.lastAttackResult = "lose";
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

    invokeTurnEndStateEffect(){
        for(let stateInstance of this.player.states){
            stateInstance.stateMaster.onTurnEnd(stateInstance);
        }
        for(let stateInstance of this.enemy.states){
            stateInstance.stateMaster.onTurnEnd(stateInstance);
        }
    }

    onTurnEnd(){
        this.setCharacterStatusAll("waiting");
        this.lastAttackResult = "";
        this.battleLog.push([this.powerMeetResult(), this.techMeetResult()]);
        this.operationHistory.push({cards: this.selectingCardIds, skillIndex: this.player.selectingSkillIndexes});
        this.enemyOperationHistory.push({cards: this.enemyCardIds, skillIndex: this.enemy.selectingSkillIndexes});

        this.player.deck.consumeCards(this.selectingCardIds);
        this.enemy.deck.consumeCards(this.enemyCardIds);
        this.selectingCardIds = [];
        this.player.selectingSkillIndexes = [];
        this.player.deck.fillDraw(this.player.totalHandCardCount());

        this.enemyCardIds = [];
        this.enemy.selectingSkillIndexes = [];
        this.enemy.deck.fillDraw(this.enemy.totalHandCardCount());
        this.pickEnemyCards();
        this.pickEnemySkill();

        this.player.resetTempBuffs();
        this.enemy.resetTempBuffs();

        this.player.attenuateAndSweepStates();
        this.enemy.attenuateAndSweepStates();

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
        return ["selectCard", "turnStarted", "playerMagic", "enemyMagic", "powerAttack", "techAttack", "SPAttack"].indexOf(this.turnStatus);
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
        if ( !skill.reusable && this.operationHistory.map((x)=>x.skillIndex).flat().includes(skillIndex)){
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
        if ( !skill.reusable && this.enemyOperationHistory.map((x)=>x.skillIndex).flat().includes(skillIndex)){
            return false;
        }
        return true;
    }

    onTurnStart(){
        this.turnInProgress = true;
        this.validateSelectingCardIds();
        this.validateSelectingSkillIds();
        this.setCharacterStatusAll("normal");
        this.turnStatus = "turnStarted";
    }

    pickEnemyCards(){
        this.enemyCardIds = this.enemy.deck.handCardIds.slice(0, 2);
    }

    pickEnemySkill(){
        for(let i=0; i<this.enemy.skills.length; i++){
            if(this.canEnemyUseSkill(i)){
                // 敵は同時に一つだけスキルを使う
                this.enemy.selectingSkillIndexes.push(i);
                return;
            }
        }
    }

    validateSelectingCardIds(){
        const uniqueCardIds = this.selectingCardIds.filter((elem, index, self) => self.indexOf(elem) === index);
        if(uniqueCardIds.length !== 2){
            console.error("selecting cards number is not exactly three");
            throw new Error();
        }
        if(!uniqueCardIds.every((x)=>this.player.deck.handCardIds)){
            console.error("using hand that player do not have");
            throw new Error();
        }
    }

    validateSelectingSkillIds(){
        const skillIndice = this.player.selectingSkillIndexes;
        if(skillIndice.length !== new Set(skillIndice).size){
            console.error("selecting skills is not unique");
            throw new Error();
        }
        if(this.player.consumingMp() > this.player.mp){
            console.error("selecting skills over cost");
            throw new Error();
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

    addState(isPlayer, stateId){
        const owner = isPlayer ? this.player : this.enemy;
        const opponent = isPlayer ? this.enemy : this.player;
        const master = this.stateLibrary.findState(stateId);
        if(!master){
            console.error(`undefined state ${stateId} is set`);
            return;
        }
        const state = new StateInstance(stateId, master, this, owner, opponent);
        owner.addState(state);
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

    setCharacterStatusAll(state){
        this.characterStatus = {
            spica: state,
            tirol: state,
            enemy: state,
        };
    }
};
