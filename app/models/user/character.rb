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
end
