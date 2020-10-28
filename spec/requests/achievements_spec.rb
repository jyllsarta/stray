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
end