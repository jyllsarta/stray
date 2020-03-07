require 'rails_helper'

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
    it 'succeeds' do
      expect(subject).to have_http_status(200)
    end
  end
end