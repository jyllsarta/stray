json.payload do
  json.user_id @user.id
  json.items @items
  json.equips do # TODO: 装備周りでクライアントでUI組む間の仮レスポンス
    json.spica do
      json.array! [1,3,5]
    end
    json.tirol do
      json.array! [4,2]
    end
  end
end