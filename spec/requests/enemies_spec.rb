require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Enemies", type: :request do
  describe "POST /enemies/:id/engage" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:do_post) { post enemy_engage_path(enemy_id: -1)}
    let(:params) do
      {}
    end
    subject do
      do_post
      response
    end
    context "succeeds" do
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     playerHp: Integer,
                                                     enemyHp: Integer,
                                                     seed: Integer,
                                                 }
                                             )
      end
    end
  end

  describe "POST /enemies/:id/engage" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:do_post) { post enemy_showdown_path(enemy_id: -1)}
    let(:params) do
      {}
    end
    subject do
      do_post
      response
    end
    context "succeeds" do
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     success: Boolean
                                                 }
                                             )
      end
    end
  end
end