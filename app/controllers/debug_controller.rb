class DebugController < ApplicationController
  class InProduction < StandardError; end
  before_action :check_environment
  def max_event
    current_user.debug_charge_max_events!
    head 204
  end

  def get_all_items
    current_user.debug_get_all_items!
    redirect_to clients_path
  end

  def set_coin
    current_user.status.update!(coin: params[:coin])
    redirect_to clients_path
  end

  private

  def current_user
    User.find(params[:user_id])
  end

  def check_environment
    # ルーティングで引かないようにしているけど、念には念を
    raise InProduction if Rails.env.production?
  end
end
