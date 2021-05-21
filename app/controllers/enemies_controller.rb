class EnemiesController < ApplicationController
  def index
    @user_strength = current_user.status.player_strength
    @enemies = Enemy.where(quest_id: params[:quest_id]).preload(enemy_cards: [:card], enemy_skills: [:skill], enemy_rewards: [])
  end

  def daily
    @user_strength = current_user.status.player_strength
    @today_reward_received = 100
    @today_reward_limit = 200
    @enemies = RaidEnemyMatchMaker.new(current_user).enemies
  end

  def engage
    quest = QuestBattle.new(current_user)
    quest.engage!(params[:enemy_id])
    render json: quest.content, status: :ok
  end

  def showdown
    quest = QuestBattle.new(current_user)
    quest.showdown!(params[:operation_history].map{|x| x.permit(skillIndex: [], cards: [])}.map(&:to_h))
    result = quest.result
    pp result unless Rails.env.test?

    render json: {success: true, isWin: result["isWin"], isDraw: result["isDraw"], rewards: result["rewards"]}, status: :ok
  end
end

