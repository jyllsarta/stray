class EnemiesController < ApplicationController
  def index
    @user = current_user
    @enemies = Enemy.all.preload(enemy_cards: [:card])
  end

  def engage
    quest = QuestBattle.new(current_user)
    quest.engage!(params[:enemy_id])
    render json: quest.content, status: :ok
  end

  def showdown
    quest = QuestBattle.new(current_user)

    result = quest.showdown!(params[:operation_history])
    pp result unless Rails.env.test?

    render json: {success: true, isWin: result["isWin"], isDraw: result["isDraw"]}, status: :ok
  end
end
