# == Schema Information
#
# Table name: user_characters
#
#  id           :integer          not null, primary key
#  hp           :integer          default(0)
#  hp_max       :integer          default(0)
#  character_id :integer          default(NULL)
#  user_id      :integer          default(0)
#

require 'rails_helper'

RSpec.describe User::Character, type: :model do
  let!(:dungeon){ create(:dungeon) }
  let(:user){ User.create }

  describe "#set_default" do
    subject { User::Character.create(user: user) }
    it "sets default hp and hp_max" do
      character = subject
      expect(character.hp).to eq(Constants.character.initial_hp_max)
      expect(character.hp_max).to eq(Constants.character.initial_hp_max)
    end
  end

  describe "#equip_item_ids" do
    let(:character){ create(:user_character, user: user) }
    subject { character.equip_item_ids }
    context "when no equip" do
      before do
        allow(character).to receive_message_chain(:equips, :map).and_return([nil, nil, nil, nil])
      end
      it "returns list of nil" do
        expect(subject).to eq([nil, nil, nil, nil])
      end
    end

    context "with equip" do
      let(:item){create(:item)}
      let(:user_item){ create(:user_item, item_id: item.id, user: user)}
      before do
        allow(character).to receive_message_chain(:equips, :map).and_return([user_item, nil, nil, nil])
      end
      it "returns list of item_ids" do
        expect(subject).to eq([item.id, nil, nil, nil])
      end
    end
  end
end
