# == Schema Information
#
# Table name: user_random_item_receive_histories
#
#  id          :bigint           not null, primary key
#  received_at :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  item_id     :integer          not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_user_random_item_receive_histories_on_user_id  (user_id)
#  receive_history                                      (user_id,received_at)
#

require 'rails_helper'

RSpec.describe User::RandomItemReceiveHistory, type: :model do
end
