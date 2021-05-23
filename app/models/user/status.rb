# == Schema Information
#
# Table name: user_statuses
#
#  id                    :bigint           not null, primary key
#  coin                  :integer          default(0), not null
#  current_dungeon_depth :integer          default(1), not null
#  event_updated_at      :datetime
#  resurrect_timer       :integer          default(0), not null
#  returns_on_death      :boolean          default(FALSE), not null
#  star                  :integer          default(0), not null
#  velocity              :integer          default(100), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  current_dungeon_id    :integer          default(1), not null
#  user_id               :integer          not null
#

class User::Status < ApplicationRecord
  class CannotSwitchDungeon < StandardError; end
  class InsufficientStar < StandardError; end
  class InsufficientCoin < StandardError; end

  belongs_to :user
  belongs_to :dungeon, foreign_key: :current_dungeon_id
  has_many :dungeon_progresses, primary_key: :user_id, foreign_key: :user_id
  has_many :items, primary_key: :user_id, foreign_key: :user_id

  def memoized_items_hash
    @_items_hash ||= items.index_by(&:item_id)
  end

  def current_dungeon_progress
    # メモ化して使い回すことによって、同一イベント中では同じオブジェクトを掴み続けさせる。
    @_current_dungeon_progress ||= dungeon_progresses.find_or_create_by!(dungeon: dungeon)
  end

  def current_dungeon_rank
    dungeon.rank(current_dungeon_depth)
  end

  def switch_dungeon!(dungeon_id, depth)
    raise CannotSwitchDungeon unless can_switch_dungeon?(dungeon_id, depth)

    self.current_dungeon_id = dungeon_id
    self.current_dungeon_depth = depth
    @_current_dungeon_progress = nil # current_dungeon_progressキャッシュが不正になるので手放す
    self.velocity = Constants.user.velocity.min
    self.save!
  end

  def tick_timer(seconds)
    self.event_updated_at += seconds
  end
  
  def next_event_at
    self.event_updated_at + Constants.default_event_interval_seconds
  end

  def calibrate_event_updated_at(time)
    self.event_updated_at = [self.event_updated_at, time - Constants.max_event_consume_time_seconds].max
    save!
  end

  def event_remain_time(time)
    time - self.event_updated_at
  end

  def manual_resurrect!
    ActiveRecord::Base.transaction do
      user.characters.map(&:resurrect)
      user.characters.map(&:save!)
      self.update!(resurrect_timer: Constants.resurrect_time_seconds)
      user.achievement_logger.post(Achievement::Event::ManualResurrect.new)
    end
  end

  def start_resurrect_timer
    self.resurrect_timer = 0
  end

  def tick_resurrect_timer(seconds)
    self.increment(:resurrect_timer, seconds)
  end

  def resurrect_progress
    (100 * self.resurrect_timer / Constants.resurrect_time_seconds).floor
  end

  def resurrect_completed?
    self.resurrect_timer >= Constants.resurrect_time_seconds
  end

  def add_coin!(amount)
    self.add_coin(amount)
    self.save!
  end

  def add_coin(amount)
    self.increment(:coin, amount)
    user.achievement_logger.post(Achievement::Event::FluctuateCoin.new(user, amount))
  end

  def consume_coin!(amount)
    raise InsufficientCoin if coin < amount
    self.decrement!(:coin, amount)
    user.achievement_logger.post(Achievement::Event::FluctuateCoin.new(user, -amount))
  end

  def add_star!(amount)
    self.add_star(amount)
    self.save!
  end

  def add_star(amount)
    self.increment(:star, amount)
    user.achievement_logger.post(Achievement::Event::FluctuateStar.new(amount))
  end

  def add_raid_star!(amount)
    with_lock do
      receivable_amount = raid_reward_receivable_limit - today_raid_reward_status.received_amount
      received_amount = [amount, receivable_amount].min
      self.add_star!(received_amount)
      today_raid_reward_status.increment(:received_amount, received_amount)
      today_raid_reward_status.save!
      received_amount
    end
  end

  def today_raid_reward_status
    @today_reward_status ||= user.today_raid_reward_statuses.find_or_initialize_by(day: Time.current)
  end

  def raid_reward_receivable_limit
    @_raid_reward_receivable_limit ||= user.won_enemies.count * 25 + 150
  end

  def consume_star!(amount)
    raise InsufficientStar if star < amount
    self.decrement!(:star, amount)
  end

  def fluctuate_velocity(delta)
    @_velocity_rank = nil
    v = (self.velocity + delta).clamp(Constants.user.velocity.min, Constants.user.velocity.max)
    self.velocity = v
  end

  def attenuate_velocity
    delta = Constants.event.attenuate_velocity_per_event
    delta *= 2 if self.velocity > Constants.event.attenuate_increase_threshold
    self.fluctuate_velocity(-delta)
  end

  # クライアントと定義を共有しているので注意
  def velocity_rank
    return @_velocity_rank if @_velocity_rank.present?
    @_velocity_rank = case
    when velocity < 150
      return 0
    when velocity < 200
      return 1
    when velocity < 300
      return 2
    else
      return 3
    end
  end

  def max_item_rank
    self.items.order(rank: :desc).first&.rank || 0
  end

  def event_wait_reduction_seconds
    # イベント短縮レリックいっこにつき2秒短縮
    @_event_wait_reduction_seconds ||= user.relics.joins(:relic).where(relics: {category: :event_time}).count * 2
  end

  def max_item_rank_for_rankup
    @_max_item_rank_for_rankup ||= (user.relics.joins(:relic).where(relics: {category: :item_rank}).count * Constants.item.additional_item_rank_per_relic + Constants.item.default_max_rank)
  end

  def skill_slot_count
    @_skill_slot_count ||= (user.relics.joins(:relic).where(relics: {category: :skill_slot}).count + Constants.skill.default_skill_slot_count)
  end

  def quest_battle_additional_hp
    # HP追加レリックの個数そのものが性能
    user.relics.joins(:relic).where(relics: {category: :hp}).count
  end

  def quest_battle_additional_power_tech_damage
    # 力技追加レリックの個数そのものが性能
    user.relics.joins(:relic).where(relics: {category: :power_tech_damage}).count
  end

  def quest_battle_additional_special_damage
    # SP追加レリックの個数そのものが性能
    user.relics.joins(:relic).where(relics: {category: :special_damage}).count
  end

  def average_item_rank
    preload_item_associations!
    user.characters.map(&:equips).flatten.map(&:user_item).compact.map(&:item_rank).sum / (Constants.equip.max_count * 2)
  end

  def won_last_boss?
    user.won_enemies.exists?(enemy_id: Constants.enemy.last_boss_id)
  end

  def player_strength
    return @_strength if @_strength
    preload_item_associations!
    @_strength = user.characters.map(&:strength).each_with_object({atk: 0, def: 0}) do |strength, hash|
      hash[:atk] += strength[:atk]
      hash[:def] += strength[:def]
    end
  end

  def return_floor_on_death
    return unless returns_on_death
    self.current_dungeon_depth -= Constants.dungeon.return_floors_on_death
    self.current_dungeon_depth = 1 if current_dungeon_depth <= 0
  end

  private

  def preload_item_associations!
    ActiveRecord::Associations::Preloader.new.preload( user, {characters: {equips: {user_item: [:item]}}})
  end

  def can_switch_dungeon?(dungeon_id, depth)
    dungeon = Dungeon.find(dungeon_id)
    # dungeon が parent を持つなら、parentがクリア済みでなければならない
    return false if dungeon.parent.present? && !dungeon.parent.cleared?(user)

    # progress を持っていなかったとしても、1Fには無条件で侵入可能
    max_depth = [user.status.dungeon_progresses.find_by(dungeon_id: dungeon_id)&.max_depth || 0, 1].max

    depth <= max_depth
  end
end
