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

        switch( category ){
            case "Damage":
                this.resolveDamage(actor, target, to_self, value);
                return;
            default:
                console.warn(`Undefined Skill Category: ${category}`);
        }
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
};
