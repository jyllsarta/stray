json.enemies do
  json.array! @enemies do |enemy|
    json.id enemy.id
    json.name enemy.name
    json.image_name enemy.image_name
    json.hp enemy.hp
    json.power enemy.power
    json.tech enemy.tech
    json.special enemy.special
    json.rank enemy.rank
    json.cards enemy.cards(@user.status.average_item_rank)
    json.skills do
      json.array! enemy.enemy_skills.order(order: :asc) do |enemy_skill|
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
  end
end
