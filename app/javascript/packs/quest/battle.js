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

        this.resetCharacterStatus();

        // デッキ回りの初期化はバトルがやるの違うのかもなと思いつつも、一旦ここ意外に役割を持たせるとそれはそれで歪むので別の需要が出てくるまで待つ
        this.player.deck.setSeededDice(this.dice);
        this.enemy.deck.setSeededDice(this.dice);

        this.player.deck.shuffle();
        this.enemy.deck.shuffle();

        this.player.deck.fillDraw();
        this.enemy.deck.fillDraw();

        this.operationHistory = [];
        this.enemyOperationHistory = [];
        this.selectingCardIds = [];
        this.selectingSkillId = null;
        this.enemySelectingSkillId = null;
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

    selectSkill(skillId){
        if(this.turnInProgress){
            return;
        }
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
            console.warn(`不正なスキル指定です！ id:${this.selectingSkillId}`);
            return;
        }
        const skill = this.player.skills.find((x)=>x.id===this.selectingSkillId);
        const effects = skill.effects;
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(true,  effect.category, effect.to_self, effect.value, skill.is_defence);
        }
        this.player.useMp(skill.cost);
        this.characterStatus.tirol = 'magic';
    }

    invokeEnemyMagic(){
        this.resetCharacterStatus();
        if(this.enemySelectingSkillId === null){
            return;
        }
        if(!this.canEnemyUseSkill(this.enemySelectingSkillId)){
            console.warn(`不正なエネミースキル指定です！...なんで？ id:${this.enemySelectingSkillId}`);
            return;
        }
        const skill = this.enemy.skills.find((x)=>x.id===this.enemySelectingSkillId);
        const effects = skill.effects;
        for(let effect of effects){
            this.skillResolver.resolveSkillEffect(false,  effect.category, effect.to_self, effect.value, skill.is_defence);
        }
        this.enemy.useMp(skill.cost);
    }

    invokePowerAttack(){
        const result = this.powerMeetResult();
        if(result === "win"){
            this.enemy.damage(this.player.damageAt("power"));
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.characterStatus.spica = 'attack';
        }
        else if(result === "lose"){
            this.player.damage(this.enemy.damageAt("power"));
            this.player.addMp(10);
            this.enemy.addMp(5);
            this.characterStatus.spica = 'lose';
        }
        else{
            this.player.addMp(40);
            this.enemy.addMp(0);
            this.characterStatus.spica = 'draw';
        }
    }

    invokeTechAttack(){
        const result = this.techMeetResult();
        if(result === "win"){
            this.enemy.damage(this.player.damageAt("tech"));
            this.player.addMp(5);
            this.enemy.addMp(10);
            this.characterStatus.spica = 'attack';
        }
        else if(result === "lose"){
            this.player.damage(this.enemy.damageAt("tech"));
            this.player.addMp(10);
            this.enemy.addMp(5);
            this.characterStatus.spica = 'lose';
        }
        else{
            this.player.addMp(40);
            this.enemy.addMp(0);
            this.characterStatus.spica = 'draw';
        }
    }

    invokeSPAttack(){
        const powerResult = this.powerMeetResult();
        const techResult = this.techMeetResult();
        if(powerResult === "win" && techResult === "win"){
            this.enemy.damage(this.player.damageAt("special"));
            this.player.addMp(0);
            this.enemy.addMp(20);
            this.characterStatus.spica = 'attack';
        }
        else if(powerResult === "lose" && techResult === "lose"){
            this.player.damage(this.enemy.damageAt("special"));
            this.player.addMp(20);
            this.enemy.addMp(0);
            this.characterStatus.spica = 'lose';
        }
        else{
            // nop
        }
    }

    onTurnEnd(){
        this.resetCharacterStatus();
        this.battleLog.push([this.powerMeetResult(), this.techMeetResult()]);
        this.operationHistory.push({cards: this.selectingCardIds, skill: this.selectingSkillId});
        this.enemyOperationHistory.push({cards: this.enemyCardIds, skill: this.enemySelectingSkillId});

        this.player.deck.consumeCards(this.selectingCardIds);
        this.enemy.deck.consumeCards(this.enemyCardIds);
        this.selectingCardIds = [];
        this.selectingSkillId = null;
        this.player.deck.fillDraw();

        this.enemyCardIds = [];
        this.enemySelectingSkillId = null;
        this.enemy.deck.fillDraw();
        this.pickEnemyCards();
        this.pickEnemySkill();

        this.player.resetTempBuffs();
        this.enemy.resetTempBuffs();
        this.turnInProgress = false;
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

    // こうして条件を書いていくと operationHistory は character の持つべきロジックだった感がある
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

    canEnemyUseSkill(skillId){
        const skill = this.enemy.skills.find((x)=>x.id===skillId);

        // MPが足りてないとダメ
        if (this.enemy.mp < skill.cost ){
            return false;
        }
        // reusable = false のスキルは一回使ってたらダメ
        if ( !skill.reusable && this.enemyOperationHistory.map((x)=>x.skill).includes(skillId)){
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
        for(let skill of this.enemy.skills){
            if(this.canEnemyUseSkill(skill.id)){
                this.enemySelectingSkillId = skill.id;
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
            tirol: 'normal'
        };
    }
};
