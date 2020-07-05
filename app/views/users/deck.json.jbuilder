json.class_cards do
  json.array! @class_cards
end

json.item_cards do
  json.array! @item_cards
end

json.average_item_rank @user.status.average_item_rank