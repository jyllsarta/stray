# == Schema Information
#
# Table name: user_characters
#
#  id           :integer          not null, primary key
#  user_id      :integer          default(0)
#  character_id :integer          default(NULL)
#  hp           :integer          default(0)
#  hp_max       :integer          default(0)
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
    self.equips.map(&:user_item).map{|ui| ui&.item_id}
  end

  def force_set_equips(item_ids)
    # 装備重複チェックは複数キャラにまたがる処理なのでこれの外側でトランザクションを張ること
    self.equips.each_with_index do |equip, i|
      # 空き枠がnilになるのは意図通り
      equip.update!(user_item: user.items.find_by(item_id: item_ids[i]))
    end
  end

  def damage!(value)
    self.hp = [self.hp - value, 0].max
    save!
  end

  def alive?
    self.hp.positive?
  end

  def dead?
    !alive?
  end

  def resurrect!
    self.update!(hp: self.hp_max)
  end

  def compacted_equips
    equips.includes(user_item: [:item]).select{|equip| equip.user_item.present?}
  end

  def parameters
    default_parameters = Constants.character.default_parameters[character_id].to_h
    compacted_equips.each_with_object(default_parameters) do |equip, hash|
      hash.merge!(equip.user_item.parameter){|_, a, b| a + b}
    end
  end

  def strength
    lambda = ->(a, b){(a + b) /2  + [a, b].min}
    params = parameters
    {
      atk: lambda.call(params[:str], params[:dex]),
      def: lambda.call(params[:def], params[:agi])
    }
  end
end
