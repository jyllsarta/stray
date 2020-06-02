class EnemiesController < ApplicationController
  def engage
    quest = QuestBattle.new(current_user)
    quest.engage!
    render json: quest.content, status: :ok
  end

  def showdown
    quest = QuestBattle.new(current_user)
    quest.showdown!([])
    render json: {success: true}, status: :ok
  end
end
