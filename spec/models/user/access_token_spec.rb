# == Schema Information
#
# Table name: user_access_tokens
#
#  id         :bigint           not null, primary key
#  token      :string(255)
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

  describe "#find_user_by_token!" do
    let(:user){ create(:user) }
    subject { User::AccessToken.find_user_by_token!(token) }
    context "token exists" do
      let!(:token) { User::AccessToken.generate(user) }
      it "returns user" do
        expect(subject).to eq(user)
      end
    end
    context "with no token" do
      let(:token) { "" }
      it "returns user" do
        expect{subject}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
