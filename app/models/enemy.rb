# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Enemy < ApplicationRecord
end
