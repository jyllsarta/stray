module.exports = class Character{
    constructor(name, imageName, hp, power, tech, special, deck, skills) {
        this.name = name;
        this.imageName = imageName;
        this.hp = hp;
        this.hp_max = hp;
        this.power = power;
        this.tech = tech;
        this.special = special;
        this.mp = 0;
        this.mp_max = 100;
        this.handCardCount = 6;
        this.deck = deck;
        this.skills = skills;
        this.resetTempBuffs();
        this.selectingSkillIndex = null;
    }

    selectingSkill(){
        return this.skills[this.selectingSkillIndex];
    }

    isAlive(){
        return this.hp > 0;
    }

    damageAt(type){
        return this[type] + this.tempBuffs[`${type}Damage`];
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

    hpRatio(){
        return this.hp / this.hp_max;
    }

    hasMp(value){
        return this.mp >= value
    }

    useMp(value){
        this.mp -= value;
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

    mpRatio(){
        return this.mp / this.mp_max;
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

    damage(value){
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
        return cards.map((c)=>c.tech).reduce((a,b)=>(a+b)) + this.tempBuffs.power;
    }
};
