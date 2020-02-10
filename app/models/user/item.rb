# == Schema Information
#
# Table name: user_items
#
#  id      :integer          not null, primary key
#  user_id :integer          default(0)
#  item_id :integer          default(0)
#  rank    :integer          default(0)
#

class User::Item < ApplicationRecord
  belongs_to :user
  belongs_to :item, class_name: "::Item"

  def parameter
    # ActiveRecord のmodel にslice をかけるとキーが文字列化するようなので symbolize_name を通してから処理する
    item.slice(:str, :dex, :def, :agi).map{|k,v| [k.to_sym, v] }.to_h.map do |name, value|
      [name, (value + value * 0.1 * rank).floor]
    end.to_h
  end
end
