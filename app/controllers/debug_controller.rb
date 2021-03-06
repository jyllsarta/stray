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

  def reset_daily_quest
    current_user.won_enemies.where("enemy_id > 1000").map(&:destroy)
    redirect_to clients_path
  end

  def set_achievement
    achievement = current_user.achievements.find_or_initialize_by(achievement_id: params[:achievement_id])
    achievement.progress = params[:progress]
    achievement.save!
    redirect_to clients_path
  end

  def clear_achievement
    current_user.achievements.destroy_all
    current_user.achievement_steps.destroy_all
    redirect_to clients_path
  end

  def open_all_dungeons
    Dungeon.all.each do |dungeon|
      dp = current_user.status.dungeon_progresses.find_or_create_by(dungeon: dungeon)
      dp.update!(cleared: true)
    end
    redirect_to clients_path
  end

  def open_all_quests
    Enemy.where(is_boss: true).each do |enemy|
      dp = current_user.won_enemies.find_or_create_by(enemy: enemy)
    end
    redirect_to clients_path
  end

  def set_all_item_rank
    current_user.items.update_all(rank: params[:rank])
    redirect_to clients_path
  end

  def edit_gacha_point
    current_user.gacha_point.update!(point: params[:point].to_i)
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
