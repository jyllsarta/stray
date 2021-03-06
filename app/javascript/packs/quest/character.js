module.exports = class Character{
    constructor(name, imageName, scaleType, hp, power, tech, special, deck, skills) {
        this.name = name;
        this.imageName = imageName;
        this.scaleType = scaleType;
        this.hp = hp;
        this.hp_max = hp;
        this.power = power;
        this.tech = tech;
        this.special = special;
        this.mp = 0;
        this.mp_max = 100;
        this.handCardCount = 5;
        this.deck = deck;
        this.skills = skills;
        this.resetTempBuffs();
        this.selectingSkillIndexes = [];
        this.selectingCardIds = [];
        this.states = [];
        this.operationHistory = [];
    }

    canUseSkill(skillIndex){
        const skill = this.skills[skillIndex];

        if(!skill){
            return false;
        }

        // パッシブスキルは能動的に発動できない
        if (skill.is_passive){
            return false;
        }

        // MPが足りてないとダメ
        if (!skill.isMpSufficient(this.mp)){
            return false;
        }

        // reusable = false のスキルは一回使ってたらダメ
        if ( !skill.reusable && this.operationHistory.map((x)=>x.skillIndex).flat().includes(skillIndex)){
            return false;
        }

        // HP条件があるときはそれを満たしていないとダメ
        if ( skill.threshold_hp && skill.threshold_hp < this.hp ) {
            return false;
        }
        return true;
    }

    selectingSkills(){
        return this.selectingSkillIndexes.map(x=>this.skills[x]);
    }

    consumingMp(){
        return this.selectingSkills().reduce((a,b)=>a+b.cost, 0);
    }

    removeSKillBySkillIndex(index){
        this.selectingSkillIndexes = this.selectingSkillIndexes.filter(x=>x!==index);
    }

    isAlive(){
        return this.hp > 0;
    }

    damageAt(type){
        const damage = this[type] + this.tempBuffs[`${type}Damage`];
        return damage > 0 ? damage : 0;
    }

    addHp(value){
        if(this.hp > this.hp_max){
            return;
        }
        this.hp += value;
        if(this.hp > this.hp_max){
            this.hp = this.hp_max;
        }
    }

    addMp(value){
        if(this.tempBuffs.usedDefenceSkill){
            return; // 防御スキルを使ったターンはMPが回復しない
        }
        if(this.mp > 100){
            return;
        }
        this.mp += value;
        if(this.mp > 100){
            this.mp = 100;
        }
    }

    setHp(value){
        this.hp = value;
    }

    setMp(value){
        this.mp = value;
    }

    hpRatio(){
        return this.hp / this.hp_max;
    }

    mpRatio(){
        return this.mp / this.mp_max;
    }

    hasMp(value){
        return this.mp >= value
    }

    useMp(value){
        this.mp -= value;
    }

    addShield(value){
        this.tempBuffs.shield += value;
    }

    totalHandCardCount(){
        return this.handCardCount + this.tempBuffs.handCardCountDelta;
    }

    resetTempBuffs(){
        this.tempBuffs = {
            shield: 0,
            power: 0,
            tech: 0,
            powerAlterTo: null,
            techAlterTo: null,
            powerDamage: 0,
            techDamage: 0,
            specialDamage: 0,
            handCardCountDelta: 0,
            usedDefenceSkill: false,
        };
    }

    damage(value, isPhysical = false){
        if(this.tempBuffs.shield > 0){
            // 防ぎきれたならシールドがダメージ値だけ減る
            if(this.tempBuffs.shield >= value){
                this.tempBuffs.shield -= value;
                value = 0;
            }
            // 防ぎきれないならダメージ値がシールド値だけ減る
            else{
                value -= this.tempBuffs.shield;
                this.tempBuffs.shield = 0;
            }
        }
        this.hp -= value;
        if(value > 0){
            for(let state of this.states.slice().reverse()){
                state.onDamage(value, isPhysical);
            }
        }
    }

    damageMp(value){
        if(this.mp < 0){
            return;
        }
        this.mp -= value;
        if(this.mp < 0){
            this.mp = 0;
        }
    }

    powerAt(cardIds){
        if(this.tempBuffs.powerAlterTo !== null){
            return this.tempBuffs.powerAlterTo;
        }

        const cards = cardIds.map((id)=>this.deck.findCard(id));
        if(cards.length === 0){
            return 0;
        }
        return cards.map((c)=>c.power).reduce((a,b)=>(a+b)) + this.tempBuffs.power;
    }

    techAt(cardIds){
        if(this.tempBuffs.techAlterTo !== null){
            return this.tempBuffs.techAlterTo;
        }

        const cards = cardIds.map((id)=>this.deck.findCard(id));
        if(cards.length === 0){
            return 0;
        }
        return cards.map((c)=>c.tech).reduce((a,b)=>(a+b)) + this.tempBuffs.tech;
    }

    addState(stateInstance){
        this.states.push(stateInstance);
        stateInstance.onAdd();
    }

    // stateId 指定で states を検索し、見つかったら返す、なければnullを返す
    findStateById(stateId){
        for(let state of this.states){
            if(state.stateId === stateId){
                return state;
            }
        }
        return null;
    }

    attenuateAndSweepStates(){
        for(let state of this.states){
            if(state.ttl > 0){
                state.ttl -= 1;
            }
        }
        this.states = this.states.filter(state=>state.ttl!==0);
    }

    hasSpecificCallbackState(callbackName){
        for(let state of this.states){
            if(state.stateMaster[callbackName]){
               return true;
            }
        }
        return false;
    }
};
