class UserItemsController < ApplicationController
  def rank_up
    current_user.status.items.find(params[:user_item_id]).rank_up!
    render json: {success: true}, status: :ok
  end
end
