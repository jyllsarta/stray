# == Schema Information
#
# Table name: user_relics
#
#  id       :bigint           not null, primary key
#  relic_id :integer          default(0)
#  user_id  :integer          default(0)
#

class User::Relic < ApplicationRecord
  belongs_to :user
  belongs_to :relic, class_name: "::Relic"
end
