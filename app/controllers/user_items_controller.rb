class UserItemsController < ApplicationController
  def rank_up
    @user = current_user
    @user.with_lock do # TODO MySQLにDBエンジンを変えたタイミングで FOR UPDATE が吐かれているかチェックする
      @item = current_user.status.items.find_by!(item_id: params[:user_item_id])
      @item.rank_up!
    end
  end
end
