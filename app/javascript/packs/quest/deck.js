module.exports = class Deck {
    constructor(cards) {
        this.cards = cards;

        // いずれもカードIDを保持する
        this.handCardIds = [];
        this.discardCardIds = [];
        this.deckCardIds = cards.map((x)=>x.id);
    }

    setSeededDice(dice){
        this.dice = dice;
    }

    currentHands(){
        return this.handCardIds.map((x)=>this.findCard(x));
    }

    consumeCards(cardIds) {
        cardIds.map((id)=>this.consume(id));
    }

    consume(id){
        this.discardCardIds.push(id);
        this.handCardIds = this.handCardIds.filter((x)=>x!==id);
    }

    findCard(id){
        return this.cards.find((x)=>x.id===id);
    }

    fillDraw(cardCount){
        if(cardCount < 2){
            cardCount = 2 // 手札枚数は絶対に2枚は確保される
        }
        if(cardCount > 8){
            cardCount = 8 // 手札枚数は8枚が上限
        }
        while(this.handCardIds.length < cardCount){
            this.draw();
        }
    }

    draw(){
        if(this.deckCardIds.length === 0){
            this.reShuffle();
        }

        this.handCardIds.push(this.deckCardIds.shift());
    }

    // リシャッフル = 捨て札のカードを全て集めてシャッフルし、山札にし直す
    reShuffle(){
        this.deckCardIds = this.discardCardIds;
        this.discardCardIds = [];
        this.shuffle();
    }

    // シャッフル = 山札のカードを切り直す
    shuffle(){
        if(!this.dice){
            console.error("please set dice");
            return;
        }

        let array = this.deckCardIds;
        for (let i = array.length - 1; i >= 0; i--) {
            const j = this.dice.randInt(0, i);
            [array[i], array[j]] = [array[j], array[i]];
        }
        this.deckCardIds = array;
    }
};
