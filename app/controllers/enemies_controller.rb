class EnemiesController < ApplicationController
  def engage
    json = {
        playerHp: 300,
        enemyHp: 50,
        seed: 234
    }.to_json
    render json: json, status: :ok
  end
  def showdown
    render json: {success: true}, status: :ok
  end
end
