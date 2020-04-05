# == Schema Information
#
# Table name: user_statuses
#
#  id                    :integer          not null, primary key
#  user_id               :integer          default(0), not null
#  event_updated_at      :datetime         default(NULL), not null
#  current_dungeon_id    :integer          default(1), not null
#  current_dungeon_depth :integer          default(1), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  resurrect_timer       :integer          default(0), not null
#

class User::Status < ApplicationRecord
  belongs_to :user
  belongs_to :dungeon, foreign_key: :current_dungeon_id
  has_many :dungeon_progresses, primary_key: :user_id, foreign_key: :user_id

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
end
