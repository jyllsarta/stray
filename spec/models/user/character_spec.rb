# == Schema Information
#
# Table name: user_characters
#
#  id           :integer          not null, primary key
#  exp          :integer          default(0)
#  hp           :integer          default(0)
#  hp_max       :integer          default(0)
#  level        :integer          default(0)
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

  describe "#force_set_equips" do
    let!(:character){ create(:user_character, user: user) }
    let!(:equip1){ create(:user_character_equip, user_character: character)}
    let!(:equip2){ create(:user_character_equip, user_character: character)}
    let!(:item){ create(:item) }
    let!(:user_item){ create(:user_item, user: user, item: item) }
    subject { character.force_set_equips(item_ids) }
    context "equip is set" do
      let(:item_ids){[item.id]}
      it "updates equips to  [item, nil]" do
        subject
        expect(character.reload.equip_item_ids).to eq([item.id, nil])
      end
    end

    context "no equip" do
      let(:item_ids){[]}
      it "updates equips to [nil, nil]" do
        subject
        expect(character.reload.equip_item_ids).to eq([nil, nil])
      end
    end
  end

  describe "#damage!" do
    let(:character){ create(:user_character, user: user) }
    subject { character.damage!(value) }
    context "hp > damage" do
      let(:value){ 10 }
      it "reduces hp" do
        expect{subject}.to change(character, :hp).by(-value)
      end
    end
    context "hp < damage" do
      let(:value){ 100000 }
      it "set hp to zero" do
        expect{subject}.to change(character, :hp).to(0)
      end
    end
  end

  describe "#alive?" do
    let(:character){ create(:user_character, user: user) }
    subject { character.alive? }
    context "hp > 0" do
      before do
        character.update(hp: 1)
      end
      it "returns true" do
        expect(subject).to be_truthy
      end
    end
    context "hp <= 0" do
      before do
        character.update(hp: 0)
      end
      it "returns true" do
        expect(subject).to be_falsey
      end
    end
  end

  describe "#dead?" do
    let(:character){ create(:user_character, user: user) }
    subject { character.dead? }
    context "hp > 0" do
      before do
        character.update(hp: 1)
      end
      it "returns true" do
        expect(subject).to be_falsey
      end
    end
    context "hp <= 0" do
      before do
        character.update(hp: 0)
      end
      it "returns true" do
        expect(subject).to be_truthy
      end
    end
  end

  describe "#resurrect!" do
    let(:character){ create(:user_character, user: user) }
    subject { character.resurrect! }
    before do
      character.update(hp: 0)
    end
    it "set hp to max" do
      expect{subject}.to change(character, :hp).to(character.hp_max)
    end
  end

  describe "#parameters" do
    let(:character){ create(:user_character, user: user) }
    let!(:item1){ create(:item, str: 100, dex: 200, def: 300, agi: 0) }
    let!(:item2){ create(:item, str: 100, dex: 200, def: 300, agi: 0) }
    let!(:user_item1){ create(:user_item, user: user, item: item1) }
    let!(:user_item2){ create(:user_item, user: user, item: item2) }
    let!(:equip1){ create(:user_character_equip, user_character: character, user_item: user_item1)}
    let!(:equip2){ create(:user_character_equip, user_character: character, user_item: user_item2)}

    subject { character.parameters }
    it "returns character's parameter" do
      expect(subject).to eq({
                                str: 210, # 100 + 100 + 10(default)
                                dex: 410, # 200 + 200 + 10(default)
                                def: 610, # 300 + 300 + 10(default)
                                agi: 10,  #   0 +   0 + 10(default)
                            })
    end
  end

  describe "#strength" do
    let(:character){ create(:user_character, user: user) }
    let!(:item1){ create(:item, str: 100, dex: 100, def: 200, agi: 0) }
    let!(:item2){ create(:item, str: 100, dex: 100, def: 200, agi: 0) }
    let!(:user_item1){ create(:user_item, user: user, item: item1) }
    let!(:user_item2){ create(:user_item, user: user, item: item2) }
    let!(:equip1){ create(:user_character_equip, user_character: character, user_item: user_item1)}
    let!(:equip2){ create(:user_character_equip, user_character: character, user_item: user_item2)}

    subject { character.strength }
    it "returns character's strength" do
      expect(subject).to eq({
                                atk: 420, # 210 + 210
                                def: 220, # (410 + 10)/2 + 10
                            })
    end
  end
end
