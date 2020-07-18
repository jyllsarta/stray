module.exports = class Character{
    constructor(name, hp, deck, skills) {
        this.name = name;
        this.hp = hp;
        this.hp_max = hp;
        this.mp = 0;
        this.deck = deck;
        this.skills = skills;
        this.resetTempBuffs();
    }

    isAlive(){
        return this.hp > 0;
    }

    atk(){
        return this.deck.cards[this.index].atk();
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
        if(this.mp > 100){
            return;
        }
        this.mp += value;
        if(this.mp > 100){
            this.mp = 100;
        }
    }

    addShield(value){
        this.tempBuffs.shield += value;
    }

    resetTempBuffs(){
        this.tempBuffs = {
            shield: 0,
            power: 0,
            tech: 0,
            powerDamage: 0,
            techDamage: 0,
            specialDamage: 0
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
        const cards = cardIds.map((id)=>this.deck.findCard(id));
        if(cards.length === 0){
            return 0;
        }
        return cards.map((c)=>c.power).reduce((a,b)=>(a+b));
    }

    techAt(cardIds){
        const cards = cardIds.map((id)=>this.deck.findCard(id));
        if(cards.length === 0){
            return 0;
        }
        return cards.map((c)=>c.tech).reduce((a,b)=>(a+b));
    }
};
