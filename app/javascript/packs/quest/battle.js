let SeededRandom = require("./seeded_random");
let SkillResolver = require("./skill_resolver");
let StateLibrary = require("./state_library");
let StateInstance = require("./state_instance");

module.exports = class Battle{
    constructor(player, enemy, seed, fieldEffectStateId) {
        this.seed = seed;
        this.dice = new SeededRandom(seed);
        this.skillResolver = new SkillResolver(this);
        this.stateLibrary = new StateLibrary();
        this.player = player;
        this.enemy = enemy;
        this.setFieldEffectStateInstance(fieldEffectStateId);

        this.turnInProgress = false;
        this.turnStatus = "selectCard";
        this.turn = 1;
        this.turnLimit = 10;

        this.setCharacterStatusAll("waiting");
        this.lastAttackResult = "";

        // デッキ回りの初期化はバトルがやるの違うのかもなと思いつつも、一旦ここ意外に役割を持たせるとそれはそれで歪むので別の需要が出てくるまで待つ
        this.player.deck.setSeededDice(this.dice);
        this.enemy.deck.setSeededDice(this.dice);

        this.player.deck.shuffle();
        this.enemy.deck.shuffle();

        this.player.deck.fillDraw(this.player.totalHandCardCount());
        this.enemy.deck.fillDraw(this.enemy.totalHandCardCount());

        this.player.selectingCardIds = [];
        this.enemy.selectingCardIds = [];

        this.battleLog = [];

        this.pickEnemyCards();
        this.pickEnemySkill();

        this.fieldEffectState?.onAdd();
        this.invokePassiveSkills();
        this.shouldShowParalyzeEffect = false;
    }

    // ***********************************************************************
    // controller
    // ***********************************************************************

    selectCard(cardId){
        if(this.turnInProgress){
            return;
        }
        if(this.player.selectingCardIds.includes(cardId)){
            this.player.selectingCardIds = this.player.selectingCardIds.filter(n => n !== cardId);
            return;
        }
        if(this.player.selectingCardIds.length === 2){
            return;
        }
        this.player.selectingCardIds.push(cardId);
    }

    selectSkill(skillIndex){
        if(this.turnInProgress){
            return;
        }
        if(!this.player.canUseSkill(skillIndex)){
            return;
        }

        // 消すのは予算判定しなくてOK
        if(this.player.selectingSkillIndexes.includes(skillIndex)){
            this.player.removeSKillBySkillIndex(skillIndex);
            return;
        }

        //スキルを積む場合は予算判定を通っていないとダメ
        const remainMp = this.player.mp - this.player.consumingMp();
        if(!this.player.skills[skillIndex].isMpSufficient(remainMp)){
            return;
        }

        this.player.selectingSkillIndexes.push(skillIndex);
    }

    playTurn(){
        this.onTurnStart();
        this.invokeTurnStartStateEffect();
        if( this.isGameEnd() ){ this.onTurnEnd(); return; } // クライアントと同じタイミングで短絡終了する
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
        if( this.isGameEnd() ){ this.onTurnEnd(); return; } // クライアントと同じタイミングで短絡終了する
        this.invokeTurnEndStateEffect();
        this.onTurnEnd();
    }

    // ***********************************************************************
    // ターンのイベント再生処理でトリガーされるメソッドたち
    // ***********************************************************************

    invokePassiveSkills(){
        for(let skill of this.player.skills.filter(x=>x.is_passive)){
            const effects = skill.effects;
            for(let effect of effects){
                this.skillResolver.resolveSkillEffect(true,  effect.category, effect.to_self, effect.value, skill, skill.is_defence);
            }    
        }
        for(let skill of this.enemy.skills.filter(x=>x.is_passive)){
            const effects = skill.effects;
            for(let effect of effects){
                this.skillResolver.resolveSkillEffect(false,  effect.category, effect.to_self, effect.value, skill, skill.is_defence);
            }    
        }
    }

    invokeTurnStartStateEffect(){
        // ・一部のFEがターン中のダメージ回数を参照する
        // ・onTurnEndでダメージを与えるスキルが無数にある
        // ・FEが最初に付与されることはほぼ保証されているし、ダメージ回数を参照する通常スキルはほぼない
        // ということでコールバックの場合のステート効果解決順は逆順にする
        for(let stateInstance of this.player.states.slice().reverse()){
            stateInstance.onTurnStart();
        }
        for(let stateInstance of this.enemy.states.slice().reverse()){
            stateInstance.onTurnStart();
        }
        if(this.fieldEffectState){
            this.fieldEffectState.onTurnStart();
        }
    }

    invokePlayerMagicStart(){
        this.turnStatus = "playerMagic";
    }

    invokePlayerMagic(skillIndex){
        if(!this.player.canUseSkill(skillIndex)){
            console.warn(`不正なスキル指定です！ idx:${skillIndex}`);
            return;
        }
        const skill = this.player.skills[skillIndex];
        const effects = skill.effects;
        this.player.useMp(skill.cost);
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(true,  effect.category, effect.to_self, effect.value, skill, skill.is_defence);
        }
        this.characterStatus.tirol = 'magic';
    }

    invokeEnemyMagicStart(){
        this.turnStatus = "enemyMagic";
    }

    invokeEnemyMagic(skillIndex){
        if(!this.enemy.canUseSkill(skillIndex)){
            // damageMpにより、使おうと思ったスキルをすかされる可能性が出たのでワーニングは表示しない
            return;
        }
        const skill = this.enemy.skills[skillIndex];
        const effects = skill.effects;
        this.enemy.useMp(skill.cost);
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(false,  effect.category, effect.to_self, effect.value, skill, skill.is_defence);
        }
        this.characterStatus.enemy = 'magic';
    }

    invokePowerAttack(){
        this.turnStatus = "powerAttack";
        const result = this.powerMeetResult();
        this.lastAttackResult = result;
        if(result === "win"){
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.enemy.damage(this.player.damageAt("power"), true);
            this.characterStatus.spica = 'attack';
            this.characterStatus.enemy = 'lose';
        }
        else if(result === "lose"){
            this.player.addMp(10);
            this.enemy.addMp(5);
            this.player.damage(this.enemy.damageAt("power"), true);
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
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.enemy.damage(this.player.damageAt("tech"), true);
            this.characterStatus.spica = 'attack2';
            this.characterStatus.enemy = 'lose';
        }
        else if(result === "lose"){
            this.player.addMp(10);
            this.enemy.addMp(5);
            this.player.damage(this.enemy.damageAt("tech"), true);
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
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.enemy.damage(this.player.damageAt("special"), true);
            this.characterStatus.spica = 'attack3';
            this.characterStatus.enemy = 'lose';
        }
        else if(powerResult === "lose" && techResult === "lose"){
            this.lastAttackResult = "lose";
            this.player.addMp(10);
            this.enemy.addMp(5);
            this.player.damage(this.enemy.damageAt("special"), true);
            this.characterStatus.spica = 'lose';
            this.characterStatus.enemy = 'attack';
        }
        else{
            // nop
        }
    }

    invokeTurnEndStateEffect(){
        // ・一部のFEがターン中のダメージ回数を参照する
        // ・onTurnEndでダメージを与えるスキルが無数にある
        // ・FEが最初に付与されることはほぼ保証されているし、ダメージ回数を参照する通常スキルはほぼない
        // ということでコールバックの場合のステート効果解決順は逆順にする
        for(let stateInstance of this.player.states.slice().reverse()){
            stateInstance.onTurnEnd(stateInstance);
        }
        for(let stateInstance of this.enemy.states.slice().reverse()){
            stateInstance.onTurnEnd(stateInstance);
        }
        if(this.fieldEffectState){
            this.fieldEffectState.onTurnEnd();
        }
    }

    onTurnStart(){
        this.turnInProgress = true;
        this.validateSelectingCardIds();
        this.validateSelectingSkillIds();
        this.setCharacterStatusAll("normal");
        this.turnStatus = "turnStarted";
    }

    onTurnEnd(){
        this.setCharacterStatusAll("waiting");
        this.lastAttackResult = "";
        this.battleLog.push([this.powerMeetResult(), this.techMeetResult()]);
        this.player.operationHistory.push({cards: this.player.selectingCardIds, skillIndex: this.player.selectingSkillIndexes});
        this.enemy.operationHistory.push({cards: this.enemy.selectingCardIds, skillIndex: this.enemy.selectingSkillIndexes});

        this.player.deck.consumeCards(this.player.selectingCardIds);
        this.enemy.deck.consumeCards(this.enemy.selectingCardIds);
        this.player.selectingCardIds = [];
        this.player.selectingSkillIndexes = [];
        this.player.deck.fillDraw(this.player.totalHandCardCount());

        this.enemy.selectingCardIds = [];
        this.enemy.selectingSkillIndexes = [];
        this.enemy.deck.fillDraw(this.enemy.totalHandCardCount());
        this.pickEnemyCards();
        this.pickEnemySkill();

        this.player.resetTempBuffs();
        this.enemy.resetTempBuffs();

        this.player.attenuateAndSweepStates();
        this.enemy.attenuateAndSweepStates();

        this.turnInProgress = false;
        this.turn++;
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

    // ***********************************************************************
    // private 的な処理
    // ***********************************************************************

    phaseIndex(){
        return ["selectCard", "turnStarted", "playerMagic", "enemyMagic", "powerAttack", "techAttack", "SPAttack"].indexOf(this.turnStatus);
    }

    shouldStopWith(callbackName){
        return this.fieldEffectState?.stateMaster[callbackName] || this.player.hasSpecificCallbackState(callbackName) || this.enemy.hasSpecificCallbackState(callbackName);
    }

    pickEnemyCards(){
        this.enemy.selectingCardIds = this.enemy.deck.handCardIds.slice(0, 2);
    }

    pickEnemySkill(){
        for(let i=0; i<this.enemy.skills.length; i++){
            // 敵は canUseSkill かつ MPが十分に溜まったスキルを使う(イグゾーストスキルでもMPがマイナスになるような積み方はしない)
            if(this.enemy.canUseSkill(i) && this.enemy.mp >= this.enemy.skills[i].cost){
                // 敵は同時に一つだけスキルを使う
                this.enemy.selectingSkillIndexes.push(i);
                return;
            }
        }
    }

    validateSelectingCardIds(){
        const uniqueCardIds = this.player.selectingCardIds.filter((elem, index, self) => self.indexOf(elem) === index);
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
    }

    isSPAttackWillHappen(){
        const powerResult = this.powerMeetResult();
        const techResult = this.techMeetResult();
        return (powerResult === "win" && techResult === "win") || (powerResult === "lose" && techResult === "lose");
    }

    powerMeetResult(category){
        if(this.player.powerAt(this.player.selectingCardIds) > this.enemy.powerAt(this.enemy.selectingCardIds)){
            return "win";
        }
        if(this.player.powerAt(this.player.selectingCardIds) < this.enemy.powerAt(this.enemy.selectingCardIds)){
            return "lose";
        }
        return "draw";
    }

    techMeetResult(category){
        if(this.player.techAt(this.player.selectingCardIds) > this.enemy.techAt(this.enemy.selectingCardIds)){
            return "win";
        }
        if(this.player.techAt(this.player.selectingCardIds) < this.enemy.techAt(this.enemy.selectingCardIds)){
            return "lose";
        }
        return "draw";
    }

    addState(isPlayer, stateId){
        const owner = isPlayer ? this.player : this.enemy;
        const opponent = isPlayer ? this.enemy : this.player;
        this.addStateToCharacter(owner, opponent, stateId);
    }

    addStateToCharacter(owner, opponent, stateId){
        const master = this.stateLibrary.findState(stateId);
        if(!master){
            console.error(`undefined state ${stateId} is set`);
            return;
        }
        const state = new StateInstance(stateId, master, this, owner, opponent);
        owner.addState(state);
    }

    setFieldEffectStateInstance(stateId){
        if(!stateId){
            return;
        }
        const master = this.stateLibrary.findState(stateId);
        if(!master){
            console.error(`undefined state ${stateId} is set`);
            return;
        }
        // fieldEffectのownerは常にplayerとして扱う
        const state = new StateInstance(stateId, master, this, this.player, this.enemy);
        this.fieldEffectState = state;
    }

    // 生存して相手が死んでれば勝ち
    isWin(){
        return this.player.isAlive() && !this.enemy.isAlive() && this.turn <= this.turnLimit;
    }

    // 両方死んでれば引き分け
    isDraw(){
        if(this.turn > this.turnLimit){
             return true;
        }
        return !this.player.isAlive() && !this.enemy.isAlive();
    }

    isGameEnd(){
        return !this.player.isAlive() || !this.enemy.isAlive() || this.turn > this.turnLimit;
    }

    setCharacterStatusAll(state){
        this.characterStatus = {
            spica: state,
            tirol: state,
            enemy: state,
        };
    }

    flashPalalyzeEffect(){
        this.shouldShowParalyzeEffect = true;
    }
};
