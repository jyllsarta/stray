class EnemiesController < ApplicationController
  def engage
    render json: {success: true}, status: :ok
  end
  def showdown
    render json: {success: true}, status: :ok
  end
end
