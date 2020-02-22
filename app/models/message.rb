# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  message    :string
#  answer     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ApplicationRecord
end
