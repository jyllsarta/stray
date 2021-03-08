class GachaController < ApplicationController
  def index
  end

  def update
    @result = current_user.gacha_point.add!(params[:amount].to_i)
  end
end
