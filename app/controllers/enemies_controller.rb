class EnemiesController < ApplicationController
  def index
    @user = current_user
    @enemies = Enemy.all.preload(enemy_cards: [:card], enemy_skills: [:skill])
  end

  def engage
    quest = QuestBattle.new(current_user)
    quest.engage!(params[:enemy_id])
    render json: quest.content, status: :ok
  end

  def showdown
    quest = QuestBattle.new(current_user)

    result = quest.showdown!(params[:operation_history].map{|x| x.permit(:skill, cards: [])}.map(&:to_h))
    pp result unless Rails.env.test?

    render json: {success: true, isWin: result["isWin"], isDraw: result["isDraw"]}, status: :ok
  end
end
