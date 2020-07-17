json.skills do
  json.array! @user_skills do |user_skill|
    user_skill.skill.to_battle_skill.keys.each do |attribute|
      json.extract! user_skill.skill, attribute
    end
    json.is_equipped user_skill.is_equipped
  end
end
