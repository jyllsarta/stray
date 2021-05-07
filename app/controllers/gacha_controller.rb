class GachaController < ApplicationController
  def index
    @user = current_user
    @pot = current_user.gacha_point.current_pot
    point = current_user.gacha_point.point
    @recent_fixed_rewards = GachaFixedReward.recent(point)
  end

  def update
    @result = current_user.gacha_point.add!(current_user, params[:amount].to_i)
    @user = current_user
    @pot = current_user.gacha_point.current_pot
    point = current_user.gacha_point.point
    @recent_fixed_rewards = GachaFixedReward.recent(point)
  end
end
