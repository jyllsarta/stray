module.exports = class SkillResolver {
    constructor(battle) {
        this.battle = battle;
    }

    resolveSkillEffect(player_side, category, to_self, value) {
        let actor;
        let target;
        if(player_side){
            actor = this.battle.player;
            target = this.battle.enemy;
        }
        else{
            actor = this.battle.enemy;
            target = this.battle.player;
        }

        // 曲芸みたいなことしてんなという自覚はある
        this[`resolve${category}`](actor, target, to_self, value);
    }

    // private

    resolveDamage(actor, target, to_self, value){
        if(to_self){
            actor.hp -= value;
        }
        else{
            target.hp -= value;
        }
    }

    resolveAddHp(actor, target, to_self, value){
        if(to_self){
            actor.hp += value;
        }
        else{
            target.hp += value;
        }
    }

    resolveAddMp(actor, target, to_self, value){
        if(to_self){
            actor.addMp(value);
        }
        else{
            target.addMp(value);
        }
    }
};
