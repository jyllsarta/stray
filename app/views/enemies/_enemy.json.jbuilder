json.id enemy.id
json.name enemy.name_with_plus(user_strength[:atk], user_strength[:def])
json.is_boss enemy.is_boss
json.image_name enemy.image_name
json.scale_type enemy.scale_type
json.hp enemy.multiplied_hp(user_strength[:atk])
json.power enemy.power
json.tech enemy.tech
json.special enemy.special
json.strength enemy.strength
json.cards enemy.cards(user_strength[:def])
json.skills do
  json.array! enemy.enemy_skills do |enemy_skill|
    enemy_skill.skill.to_battle_skill.keys.each do |attribute|
      json.extract! enemy_skill.skill, attribute
    end
  end
end
json.rewards do
  json.array! enemy.enemy_rewards do |reward|
    json.extract! reward, :giftable_type, :giftable_id, :amount
  end
end
