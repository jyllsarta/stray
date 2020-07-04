json.deck do
  json.array! @deck
end

json.average_item_rank @user.status.average_item_rank