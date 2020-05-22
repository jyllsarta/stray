require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Relics", type: :request do
  describe "POST /relics" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:relic){ create(:relic) }
    let(:do_post) { post relics_path(relic_id: relic.id)}
    let(:params) do
      {}
    end
    subject do
      do_post
      response
    end
    context "succeeds" do
      before do
        user.status.add_star!(1000)
      end
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     success: Boolean
                                                 }
                                             )
      end
    end
    context "no star" do
      before do
        user.status.add_star!(0)
      end
      it 'fails' do
        expect(subject).to have_http_status(400)
      end
    end
  end
end