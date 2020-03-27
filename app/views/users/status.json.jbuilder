json.payload do
  json.user_id @user.id
  json.items @items
  json.status @status, :current_dungeon_id, :current_dungeon_depth, :current_dungeon_rank
  json.characters do
    json.spica @user.characters.spica.first.attributes
    json.tirol @user.characters.tirol.first.attributes
  end
  json.equips do
    json.spica do
      json.array! @spica_equips
    end
    json.tirol do
      json.array! @tirol_equips
    end
  end
end