json.payload do
  json.user_id @user.id
  json.items @items
  json.equips do
    json.spica do
      json.array! @spica_equips
    end
    json.tirol do
      json.array! @tirol_equips
    end
  end
end