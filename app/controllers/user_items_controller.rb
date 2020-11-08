class UserItemsController < ApplicationController
  def rank_up
    @user = current_user
    @item = current_user.status.items.find_by!(item_id: params[:user_item_id])
    @item.rank_up!(@user, params[:count].to_i)
  end
end
