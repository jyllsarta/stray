# == Schema Information
#
# Table name: quests
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_quest_id :integer
#

require 'rails_helper'

RSpec.describe Quest, type: :model do
end
