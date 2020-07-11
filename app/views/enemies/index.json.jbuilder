json.enemies do
  json.array! @enemies do |enemy|
    json.id enemy.id
    json.name enemy.name
    json.hp enemy.hp
    json.rank enemy.rank
    json.cards enemy.cards(@user.status.average_item_rank)
    json.skills do
      json.array! enemy.enemy_skills do |enemy_skill|
        enemy_skill.skill.attributes.except('created_at', 'updated_at').keys.each do |attribute|
          json.extract! enemy_skill.skill, attribute
        end
      end
    end
  end
end
