# == Schema Information
#
# Table name: relics
#
#  id              :bigint           not null, primary key
#  cost            :integer          default(0)
#  description     :string(255)
#  name            :string(255)
#  rank            :integer          default(0)
#  type            :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_relic_id :integer
#

class Relic < ApplicationRecord
end
