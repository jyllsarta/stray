# == Schema Information
#
# Table name: user_statuses
#
#  id                    :bigint           not null, primary key
#  coin                  :integer          default(0), not null
#  current_dungeon_depth :integer          default(1), not null
#  event_updated_at      :datetime         default(NULL), not null
#  resurrect_timer       :integer          default(0), not null
#  star                  :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  current_dungeon_id    :integer          default(1), not null
#  user_id               :integer          default(0), not null
#

class User::Status < ApplicationRecord
  class CannotSwitchDungeon < StandardError; end

  belongs_to :user
  belongs_to :dungeon, foreign_key: :current_dungeon_id
  has_many :dungeon_progresses, primary_key: :user_id, foreign_key: :user_id
  has_many :items, primary_key: :user_id, foreign_key: :user_id

  def current_dungeon_progress
    dungeon_progresses.find_or_create_by!(dungeon: dungeon)
  end

  def current_dungeon_rank
    dungeon.rank(current_dungeon_depth)
  end

  def at_boss_floor?
    # 「その次のフロアを踏んだことがない」ならばそのフロアのボスを倒していない
    dungeon.is_boss_floor?(current_dungeon_depth) && current_dungeon_progress.unexplored?(current_dungeon_depth + 1)
  end

  def switch_dungeon!(dungeon_id, depth)
    raise CannotSwitchDungeon unless can_switch_dungeon?(dungeon_id, depth)

    self.current_dungeon_id = dungeon_id
    self.current_dungeon_depth = depth
    self.save!
  end

  def tick_timer!(seconds)
    self.event_updated_at += seconds
    save!
  end
  
  def next_event_at
    self.event_updated_at + Constants.default_event_interval_seconds
  end

  def calibrate_event_updated_at(time)
    self.event_updated_at = [self.event_updated_at, time - Constants.max_event_consume_time_seconds].max
    save!
  end

  def manual_resurrect!
    ActiveRecord::Base.transaction do
      user.characters.map(&:resurrect!)
      self.update!(resurrect_timer: Constants.resurrect_time_seconds)
    end
  end

  def start_resurrect_timer!
    self.update!(resurrect_timer: 0)
  end

  def tick_resurrect_timer!(seconds)
    self.increment!(:resurrect_timer, seconds)
  end

  def resurrect_progress
    (100 * self.resurrect_timer / Constants.resurrect_time_seconds).floor
  end

  def resurrect_completed?
    self.resurrect_timer >= Constants.resurrect_time_seconds
  end

  def add_coin!(amount)
    self.increment!(:coin, amount)
  end

  def consume_coin!(amount)
    self.decrement!(:coin, amount)
  end

  def add_star!(amount)
    self.increment!(:star, amount)
  end

  def consume_star!(amount)
    self.decrement!(:star, amount)
  end

  def max_item_rank
    self.items.order(rank: :desc).first&.rank || 0
  end

  private

  def can_switch_dungeon?(dungeon_id, depth)
    dungeon = Dungeon.find(dungeon_id)
    # dungeon が parent を持つなら、parentがクリア済みでなければならない
    return false if dungeon.parent.present? && !dungeon.parent.cleared?(user)

    # progress を持っていなかったとしても、1Fには無条件で侵入可能
    max_depth = user.status.dungeon_progresses.find_by(dungeon_id: dungeon_id)&.max_depth || 1

    depth <= max_depth
  end
end
