require 'rails_helper'

RSpec.describe GiftableReceiver::Skill, type: :model do
  let(:receiver){ GiftableReceiver::Skill.new(skill.id, amount) }
  let(:user){ create(:user) }
  let!(:skill){ create(:skill) }
  let!(:user_status){ create(:user_status, user: user) }
  let(:amount){ 1 }

  describe "#receive!" do
    subject{ receiver.receive!(user) }

    context "adds skill" do
      it "succeeds" do
        expect{ subject }.to change(user.skills.reload, :count).by(1)
      end
    end
  end
  describe "#received_content_message" do
    subject{ receiver.received_content_message }

    it "returns text" do
      expect(subject).to eq("スキル：#{skill.name}を習得！")
    end
  end
end
