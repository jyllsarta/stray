require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Achievements", type: :request do
  describe "POST /achievenents/complete" do
    let!(:achievement){ create(:achievement, type: "Achievement::Type::ClickFieldCharacter") }
    include_context("stub_current_user")
    let!(:user){ User.create }
    let(:do_post) { post complete_achievements_path, params: params }
    let(:params) do
      {
        event_name: "click_field_character",
      }
    end
    subject do
      do_post
      response
    end
    context "succeeds" do
      it 'succeeds' do
        expect(subject).to have_http_status(204)
      end
    end
    context "proceeds achievement" do
      it 'fails' do
        subject
        expect(user.achievements.reload.exists?(achievement: achievement)).to eq(true)
      end
    end
  end

  describe "GET /achievenents/cache" do
    include_context("stub_current_user")
    let!(:user){ create(:user) }
    let(:do_get) { get cache_achievements_path + ".json" }
    subject do
      do_get
      response
    end
    before do
      Achievement::StepClearedCache.write(user, 1)
    end
    context "succeeds" do
      it 'succeeds' do
        expect(subject.body).to match_json_expression(
          completed_achievements: [1]
        )
      end
    end
    it "deletes cache" do
      subject
      expect(Achievement::StepClearedCache.read(user)).to eq([])
    end
  end
end