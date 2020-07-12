module.exports = class Effect {
    constructor(category, to_self, value) {
        this.category = category;
        this.to_self = to_self;
        this.value = value;
    }
};
