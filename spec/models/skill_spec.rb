# == Schema Information
#
# Table name: skills
#
#  id               :bigint           not null, primary key
#  cost             :integer          default(0), not null
#  description      :string(255)
#  effect1_category :string(255)
#  effect1_to_self  :boolean
#  effect1_value    :integer
#  effect2_category :string(255)
#  effect2_to_self  :boolean
#  effect2_value    :integer
#  effect3_category :string(255)
#  effect3_to_self  :boolean
#  effect3_value    :integer
#  for_player       :boolean          default(TRUE), not null
#  icon_image_path  :string(255)
#  is_defence       :boolean          default(FALSE), not null
#  is_exhaust       :boolean          default(FALSE), not null
#  name             :string(255)      not null
#  reusable         :boolean          default(FALSE), not null
#  threshold_hp     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Skill, type: :model do
  let(:user){ create(:user) }

  describe "#learn!" do
    subject do
      skill.learn!(user)
    end

    let(:skill){ create(:skill) }

    context "unlearned" do
      it "can get" do
        expect{subject}.to change(user.skills, :length).by(1)
      end
    end

    context "already learned" do
      before do
        user.skills.create!(skill: skill)
      end
      it "cannot get" do
        expect{subject}.to_not change(user.skills, :length)
      end
    end
  end

  describe "#to_battle_skill" do
    let(:skill){ create(:skill) }
    subject do
      skill.to_battle_skill
    end


    context "unlearned" do
      it "can get" do
        expect(subject).to match_json_expression(
                               {
                                   "cost"=>0,
                                   "description"=>"基本の魔法",
                                   "effect1_category"=>"Damage",
                                   "effect1_to_self"=>false,
                                   "effect1_value"=>1,
                                   "effect2_category" => "AddShield",
                                   "effect2_to_self" => true,
                                   "effect2_value" => 1,
                                   "effect3_category" => "AddMp",
                                   "effect3_to_self" => true,
                                   "effect3_value" => 5,
                                   "id"=>Integer,
                                   "is_defence"=>false,
                                   "is_exhaust"=>false,
                                   "threshold_hp"=>nil,
                                   "name"=>"ファイア",
                                   "reusable"=>false
                               })  # 適当なので、モデル変更などでわずらわしくなったタイミングでちゃんと書き直す
      end
    end
  end
end
