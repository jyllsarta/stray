# == Schema Information
#
# Table name: user_characters
#
#  id           :bigint           not null, primary key
#  exp          :integer          default(0), not null
#  hp           :integer          default(0), not null
#  hp_max       :integer          default(0), not null
#  level        :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer          default(NULL), not null
#  user_id      :integer          not null
#

require 'rails_helper'

RSpec.describe User::Character, type: :model do
  let!(:dungeon){ create(:dungeon) }
  let!(:item){ create(:item, id: 1) unless Item.exists?(id: 1) }
  let!(:item2){ create(:item, id: 2) unless Item.exists?(id: 2) }
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
        allow(character).to receive_message_chain(:equips, :reload, :map).and_return([nil, nil, nil, nil])
      end
      it "returns list of nil" do
        expect(subject).to eq([nil, nil, nil, nil])
      end
    end

    context "with equip" do
      let(:item){create(:item)}
      let(:user_item){ create(:user_item, item_id: item.id, user: user)}
      before do
        allow(character).to receive_message_chain(:equips, :reload, :map).and_return([user_item, nil, nil, nil])
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

      context "achievement" do
        before do
          allow(user).to receive_message_chain(:achievement_logger, :post)
        end
        it "posts achievement" do
          subject
          expect(user).to have_received(:achievement_logger)
        end
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

  describe "#damage" do
    let(:character){ create(:user_character, user: user) }
    subject { character.damage(value) }
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

  describe "#resurrect" do
    let(:character){ create(:user_character, user: user) }
    subject { character.resurrect }
    before do
      character.update(hp: 0)
    end
    it "set hp to max" do
      expect{subject}.to change(character, :hp).to(character.hp_max)
    end
  end

  describe "#rank" do
    let(:character){ create(:user_character, character_id: "spica" , user: user) }
    subject { character.rank }
    it "is 1" do
      expect(subject).to eq(1)
    end

    context "has rank relic" do
      let!(:relic){create(:relic, category: "spica_rank")}
      let!(:user_relic){create(:user_relic, relic: relic, user: user)}
      it "is 2" do
        expect(subject).to eq(2)
      end
    end
  end

  describe "#parameters" do
    let(:character){ create(:user_character, character_id: "spica" , user: user) }
    let!(:item1){ create(:item, str: 100, dex: 200, def: 300, agi: 0, base_rank: 1) } # [1,2,3,0] の装備ができる
    let!(:item2){ create(:item, str: 100, dex: 200, def: 300, agi: 0, base_rank: 1) }
    let!(:user_item1){ create(:user_item, user: user, item: item1) }
    let!(:user_item2){ create(:user_item, user: user, item: item2) }
    let!(:equip1){ create(:user_character_equip, user_character: character, user_item: user_item1)}
    let!(:equip2){ create(:user_character_equip, user_character: character, user_item: user_item2)}

    subject { character.parameters }
    it "returns character's parameter" do
      expect(subject).to eq({
                                str: 12, # 1 + 1 + 10(default)
                                dex: 14, # 2 + 2 + 10(default)
                                def: 16, # 3 + 3 + 10(default)
                                agi: 10, # 0 + 0 + 10(default)
                            })
    end

    context "has rank relic" do
      let!(:relic){create(:relic, category: :spica_rank)}
      let!(:user_relic){create(:user_relic, relic: relic, user: user)}
      it "grows up with rank" do
        expect(subject).to eq({
                                  str: 502, # 1 + 1 + 500(rank2)
                                  dex: 504, # 2 + 2 + 500
                                  def: 506, # 3 + 3 + 500
                                  agi: 500, # 0 + 0 + 500
                              })
      end
    end
  end

  describe "#strength" do
    let(:character){ create(:user_character, user: user) }
    let!(:item1){ create(:item, str: 1000, dex: 1000, def: 2000, agi: 0, base_rank: 1) } # [10,10,20,0] の装備ができる
    let!(:item2){ create(:item, str: 1000, dex: 1000, def: 2000, agi: 0, base_rank: 1) } # [10,10,20,0] の装備ができる
    let!(:user_item1){ create(:user_item, user: user, item: item1) }
    let!(:user_item2){ create(:user_item, user: user, item: item2) }
    let!(:equip1){ create(:user_character_equip, user_character: character, user_item: user_item1)}
    let!(:equip2){ create(:user_character_equip, user_character: character, user_item: user_item2)}

    subject { character.strength }
    it "returns character's strength" do
      expect(subject).to eq({
                                atk: 60, # 30 + 30
                                def: 40, # (50 + 10)/2 + 10
                            })
    end
  end

  describe "#gain_exp" do
    let(:character){ create(:user_character, user: user) }

    subject { character.gain_exp(value) }
    context "< threshold" do
      let(:value){ Constants.character.level_up_exp - 1 }
      it "just gains exp" do
        expect{subject}.to change(character, :exp).by(value)
      end
    end
    context ">> threshold" do
      let(:value){ Constants.character.level_up_exp * 2 }
      it "also level up" do
        expect{subject}.to change(character, :level).by(2)
      end
      it "grows hp_max" do
        expect{subject}.to change(character, :hp_max).by(Constants.character.gain_hp_per_level * 2)
      end
    end
  end
end
