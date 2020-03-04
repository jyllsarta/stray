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
    subject { user.register_name(name: name, password: password) }
    let(:name){ "Taro" }
    let(:password){ "my secret password" }
    context "succeeds" do
      it "succeeds" do
        expect{ subject }.to_not raise_error
        expect(user.reload.name).to eq(name)
        expect(user.password_hash.present?).to be_truthy
      end
    end
    context "error" do
      context "name was empty" do
        let(:name){ "" }
        it "fails" do
          expect{ subject }.to raise_error(User::EmptyName)
        end
      end
      context "password was empty" do
        let(:password){ "" }
        it "fails" do
          expect{ subject }.to raise_error(User::EmptyPassword)
        end
      end
      context "existing user already have same name" do
        before do
          user = User.create
          user.register_name(name: name, password: "some another password")
        end
        it "fails" do
          expect{ subject }.to raise_error(User::AlreadyUsed)
        end
      end
    end
  end

  describe "#equip_no_duplicate?" do
    let(:user){ create(:user) }
    subject { user.equip_no_duplicate? }
    context "no duplicate" do
      before do
        allow(user.characters).to receive_message_chain(:map, :flatten).and_return([1,2,3,4,5,6,7,8])
      end
      it "succeeds" do
        expect(subject).to be_truthy
      end
    end
    context "duplicate" do
      before do
        allow(user.characters).to receive_message_chain(:map, :flatten).and_return([1,1,3,4,5,6,7,8])
      end
      it "succeeds" do
        expect(subject).to be_falsey
      end
    end
  end
end
