module.exports = class
SkillResolver {
    constructor(battle) {
        this.battle = battle;
    }

    resolveSkillEffect(player_side, category, to_self, value, isDefenceSkill) {
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

        if(isDefenceSkill){
            actor.tempBuffs.usedDefenceSkill = true;
        }

        // 曲芸みたいなことしてんなという自覚はある
        this[`resolve${category}`](actor, target, to_self, value);
    }

    // private

    resolveAddState(actor, target, to_self, value){
        this.battle.addState(to_self, value);
    }

    resolveDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.damage(value);
    }

    resolveFireDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        const stateId = 2007; // ブレイクのステートID
        if(main.findStateById(stateId)){
            value *= 2;
        }
        main.damage(value);
    }

    resolveStormDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        const opponent = to_self ? target : actor;
        const stateId = 2010; // ストーム状態のステートID
        // ストームダメージを食らう側から見た敵 = (大抵は)プレイヤー がストームのステートを持っているかどうか
        const storm = opponent.findStateById(stateId);
        const additionalDamage = storm ? storm.condition.value : 0;

        main.damage(value + additionalDamage);
    }

    // ストームを持っていなければ付与、持っていればスタックを1増加
    resolveCheckStorm(actor, target, to_self, value){
        const owner = to_self ? actor : target;
        const opponent = to_self ? target : actor;
        const stateId = 2010; // ストーム状態のステートID
        const storm = owner.findStateById(stateId)
        if(!storm){
            this.battle.addStateToCharacter(owner, opponent, stateId);
        }
        else{
            storm.condition.value += 1;
        }
    }

    resolveAddHp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.addHp(value);
    }

    resolveAddMp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.addMp(value);
    }

    resolveSetHp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.setHp(value);
    }

    resolveSetMp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.setMp(value);
    }

    resolveAddHpOverflow(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.hp += value;
    }

    resolveAddMpOverflow(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.mp += value;
    }

    resolveDamageMp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.mp -= value;
        if(main.mp < 0){
            main.mp = 0;
        }
    }

    resolveAddShield(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.addShield(value);
    }

    resolveAddSpDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.specialDamage += value;
    }

    resolveAddPowerDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.powerDamage += value;
    }

    resolveAddTechDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.techDamage += value;
    }

    resolveAddSpDamageForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.special += value;
    }

    resolveAddPowerDamageForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.power += value;
    }

    resolveAddTechDamageForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tech += value;
    }

    resolveAddPower(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.power += value;
    }

    resolveAddTech(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.tech += value;
    }

    resolveAlterPower(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.powerAlterTo = value;
    }

    resolveAlterTech(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.techAlterTo = value;
    }

    resolveAddHandForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.handCardCount += value;
    }

    resolveReduceHandForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.handCardCount -= value;
    }

    resolveReduceHand(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.handCardCountDelta -= value;
    }

    resolveUpgradeDeck(actor, target, to_self, value){
        const main = to_self ? actor : target;
        for(let card of main.deck.cards){
            card.power += value;
            card.tech += value;
        }
    }

    resolveCalamity(actor, target, to_self, value){
        const main = to_self ? actor : target;
        const multiplier = value;
        for(let skill of main.skills){
            for(let effect of skill.effects) {
                effect.value *= multiplier;
            }
        }
        // カラミティ本体のID直接指定
        this.battle.addState(to_self, 2001);
    }

    resolveBrossom(actor, target, to_self, value){
        const main = to_self ? actor : target;

        if(main.hp !== 1){
            return;
        }

        //どうせガチガチ結合スキルなので、プレイヤー専用前提で作っちゃう
        if(this.battle.powerMeetResult() !== "win" || this.battle.techMeetResult() !== "win"){
            return;
        }

        for(let skill of main.skills){
            if(skill.id === 10410){ // ガチガチ結合いやー！ 自身は再使用可能にならない
                continue;
            }
            if(skill.is_passive){ // パッシブに∞つくのも邪魔なのでつけない
                continue;
            }
            skill.reusable = true;
        }
        main.setMp(200);
    }

    resolveAddPointToWeaker(actor, target, to_self, value){
        const main = to_self ? actor : target;
        const cardIds = to_self ? this.battle.selectingCardIds : this.battle.enemyCardIds;
        if(main.powerAt(cardIds) > main.techAt(cardIds)){
            main.tempBuffs.tech += value;
        }
        else if(main.powerAt(cardIds) < main.techAt(cardIds)){
            main.tempBuffs.power += value;
        }
        else{
            main.tempBuffs.power += value;
            main.tempBuffs.tech += value;
        }
    }
};
