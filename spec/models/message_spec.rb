# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  answer     :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'rails_helper'

RSpec.describe Message, type: :model do
end
