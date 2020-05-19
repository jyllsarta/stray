# == Schema Information
#
# Table name: user_relics
#
#  id       :bigint           not null, primary key
#  relic_id :integer          default(0)
#  user_id  :integer          default(0)
#

require 'rails_helper'

RSpec.describe User::Relic, type: :model do
end
