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
  describe "#create" do
    let!(:dungeon){ create(:dungeon) }
    subject { User.create }
    it "succeeds" do
      expect{ subject }.to_not raise_error
    end
    it "creates record set" do
      user = subject
      aggregate_failures do
        expect(user.status.present?).to be_truthy
        expect(user.characters.length).to eq(2)
        expect(user.characters.tirol.first.equips.length).to eq(4)
        expect(user.characters.spica.first.equips.length).to eq(4)
      end
    end
  end
  describe "#register_name" do
    before do
      # name の重複は許されていないので、全滅させて空間を開けておく
      User.delete_all
    end
    let(:user){ create(:user) }
    let(:name){ "Taro" }
    let(:password){ "my secret password" }
    subject { user.register_name(name: name, password: password) }
    context "succeeds" do
      it "succeeds" do
        expect{ subject }.to_not raise_error
        expect(user.reload.name).to eq(name)
        expect(user.password_hash.present?).to be_truthy
      end
    end
  end
end
