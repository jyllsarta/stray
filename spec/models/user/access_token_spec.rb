# == Schema Information
#
# Table name: user_access_tokens
#
#  id         :integer          not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'rails_helper'

RSpec.describe User::AccessToken, type: :model do
  describe "#create" do
    let(:user){ create(:user) }
    subject { User::AccessToken.generate(user) }
    it "returns token string" do
      expect(subject.class).to eq(String)
    end
    it "creates record" do
      expect{ subject }.to change(User::AccessToken, :count).by(1)
    end
  end
end
