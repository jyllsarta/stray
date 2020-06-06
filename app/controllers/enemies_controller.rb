class EnemiesController < ApplicationController
  def engage
    quest = QuestBattle.new(current_user)
    quest.engage!
    render json: quest.content, status: :ok
  end

  def showdown
    quest = QuestBattle.new(current_user)
    result = quest.showdown!(params[:operation_history])
    render json: {success: true, isWin: result}, status: :ok
  end
end
