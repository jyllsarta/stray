class RelicsController < ApplicationController
  def create
    Relic.find(params[:relic_id]).obtain!(current_user)
    render json: {success: true}, status: :ok
  end
end
