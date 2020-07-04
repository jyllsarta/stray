json.enemies do
  json.array! @enemies do |enemy|
    json.id enemy.id
    json.name enemy.name
    json.hp enemy.hp
    json.rank enemy.rank
    json.cards enemy.cards(@user.status.average_item_rank)
  end
end
