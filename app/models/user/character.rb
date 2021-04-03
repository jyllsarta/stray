# == Schema Information
#
# Table name: user_characters
#
#  id           :bigint           not null, primary key
#  exp          :integer          default(0), not null
#  hp           :integer          default(0), not null
#  hp_max       :integer          default(0), not null
#  level        :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer          default(NULL), not null
#  user_id      :integer          not null
#

class User::Character < ApplicationRecord
  belongs_to :user
  has_many :equips, foreign_key: :user_character_id
  enum character_id: { spica: 1, tirol: 2 }
  before_create :set_default

  def set_default
    self.hp = Constants.character.initial_hp_max
    self.hp_max = Constants.character.initial_hp_max
  end

  def equip_item_ids
    self.equips.reload.map(&:user_item).map{|ui| ui&.item_id}
  end

  def force_set_equips(item_ids)
    # 装備重複チェックは複数キャラにまたがる処理なのでこれの外側でトランザクションを張ること
    self.equips.each_with_index do |equip, i|
      # 空き枠がnilになるのは意図通り
      equip.user_item_id = user.items.find_by(item_id: item_ids[i])&.id
    end
    User::Character::Equip.import!(self.equips.to_a, on_duplicate_key_update: [:user_item_id])
    user.achievement_logger.post(Achievement::Event::EditEquip.new(user))
  end

  def damage(value)
    self.hp = [self.hp - value, 0].max
  end

  def alive?
    self.hp.positive?
  end

  def dead?
    !alive?
  end

  def resurrect
    self.hp = self.hp_max
  end

  def rank
    Relic.rank_for(user, "#{character_id}_rank".to_sym) + 1
  end

  def parameters
    return @_parameters if @_parameters
    default_parameters = Constants.character.default_parameters["rank_#{rank}"].to_h
    @_parameters = compacted_equips.each_with_object(default_parameters) do |equip, hash|
      hash.merge!(equip.user_item.parameter){|_, a, b| a + b}
    end
    @_parameters
  end

  def strength
    lambda = ->(a, b){(a + b) /2  + [a, b].min}
    params = parameters
    {
      atk: lambda.call(params[:str], params[:dex]),
      def: lambda.call(params[:vit], params[:agi])
    }
  end

  def gain_exp(value)
    increment(:exp, value)
    while can_level_up?
      level_up
    end
  end

  private

  def can_level_up?
    self.exp >= Constants.character.level_up_exp
  end

  def level_up
    self.decrement(:exp, Constants.character.level_up_exp - 1)
    self.increment(:level)
    self.hp_max = hp_max_at(level)
  end

  def hp_max_at(level)
    Constants.character.initial_hp_max + level * Constants.character.gain_hp_per_level
  end

  def compacted_equips
    equips.includes(user_item: [:item]).select{|equip| equip.user_item.present?}
  end
end
