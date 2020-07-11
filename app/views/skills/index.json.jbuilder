json.skills do
  json.array! @user_skills do |user_skill|
    user_skill.skill.attributes.except('created_at', 'updated_at', 'for_player').keys.each do |attribute|
      json.extract! user_skill.skill, attribute
    end
    json.is_equipped user_skill.is_equipped
  end
end
