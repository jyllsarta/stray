# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  name          :string
#  password_hash :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    # あとでちゃんとfactory書くから許して...
    `RAILS_ENV=test bundle exec rails db:seed`
  end
  describe "create user" do
    subject { User.create }
    it "succeed" do
      expect{subject}.to_not raise_error
    end
    it "creates record" do
      expect{subject}.to change(User, :count).by(1)
    end
  end
end
