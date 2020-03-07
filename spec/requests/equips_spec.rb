require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Equips", type: :request do
  describe "POST /equips" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:do_post) { post user_equips_edit_path(user_id: -1), params: params }
    let(:params) do
      {
          spica: [],
          tirol: [],
      }
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
    context "someone has duplicate equips" do
      before do
        allow(user).to receive(:equip_no_duplicate?).and_return(false)
      end
      it 'fails' do
        expect(subject).to have_http_status(400)
      end
    end
  end
end