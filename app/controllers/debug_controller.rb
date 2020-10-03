class DebugController < ApplicationController
  class InProduction < StandardError; end
  before_action :check_environment
  def max_event
    current_user.debug_charge_max_events!
    head 204
  end

  def some_event
    current_user.status.update!(event_updated_at: current_user.status.event_updated_at - (params[:seconds]).to_i)
    head 204
  end

  def get_all_items
    current_user.debug_get_all_items!
    redirect_to clients_path
  end

  def set_coin
    current_user.status.update!(coin: params[:coin])
    redirect_to clients_path
  end

  def set_star
    current_user.status.update!(star: params[:star])
    redirect_to clients_path
  end

  def set_depth
    current_user.status.update!(current_dungeon_depth: params[:depth])
    redirect_to clients_path
  end

  def set_velocity
    current_user.status.update!(velocity: params[:velocity])
    redirect_to clients_path
  end

  def learn_all_user_skills
    Skill.where(for_player: true).each do |skill|
      skill.learn!(current_user) unless current_user.skills.exists?(skill: skill)
    end
    redirect_to clients_path
  end

  def clear_quest
    Enemy.where(quest_id: params[:clear_quest_id]).each do |enemy|
      current_user.won_enemies.find_or_create_by(enemy: enemy)
    end
    redirect_to clients_path
  end

  def reset_quest
    enemy_ids = Enemy.where(quest_id: params[:reset_quest_id]).ids
    current_user.won_enemies.where(enemy_id: enemy_ids).map(&:destroy)
    redirect_to clients_path
  end

  private

  def current_user
    User.find(params[:user_id])
  end

  def check_environment
    # ルーティングで引かないようにしているけど、念には念を
    raise InProduction if Rails.env.production?
  end
end
