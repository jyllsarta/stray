module.exports = class Character{
    constructor(hp) {
        this.hp = hp;
    }

    isAlive(){
        return this.hp > 0;
    }
};
