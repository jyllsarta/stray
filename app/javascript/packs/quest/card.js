module.exports = class Card {
    constructor(id, name, str, dex, def, agi) {
        this.id = id;
        this.name = name;
        this.str = str;
        this.dex = dex;
        this.def = def;
        this.agi = agi;
    }

    atk(){
        return this.str + this.dex + this.def + this.agi;
    }
};
