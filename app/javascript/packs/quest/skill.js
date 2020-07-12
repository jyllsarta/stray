module.exports = class Skill {
    constructor(id, name, cost, reusable, is_defence, effects) {
        this.id = id;
        this.name = name;
        this.cost = cost;
        this.reusable = reusable;
        this.is_defence = is_defence;
        this.effects = effects;
    }
};
