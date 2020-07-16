module.exports = class Character{
    constructor(name, hp, deck, skills) {
        this.name = name;
        this.hp = hp;
        this.hp_max = hp;
        this.mp = 0;
        this.deck = deck;
        this.skills = skills;
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
