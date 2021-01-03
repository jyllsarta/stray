# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  answer     :string(255)
#  message    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#

require 'rails_helper'

RSpec.describe Message, type: :model do
end
