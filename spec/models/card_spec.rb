# == Schema Information
#
# Table name: cards
#
#  id         :bigint           not null, primary key
#  agi        :integer          default(0)
#  def        :integer          default(0)
#  dex        :integer          default(0)
#  name       :string(255)
#  str        :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Card, type: :model do
end
