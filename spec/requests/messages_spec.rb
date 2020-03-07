require 'rails_helper'

RSpec.describe "Messages", type: :request do
  describe "GET /messages" do
    let(:do_get) { get messages_path }
    subject do
      do_get
      response
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
      # HTML なのでレスポンス形式はテストしない
    end
  end

  describe "POST /messages" do
    include_context("stub_current_user")
    let(:user){ create(:user) }
    let(:do_post) { post messages_path, params: params }
    subject do
      do_post
      response
    end
    context "succeeds" do
      let(:params) do
        {
            message: "test message"
        }
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
    context "message was empty" do
      let(:params) do
        {
            message: ""
        }
      end
      it 'fails' do
        expect(subject).to have_http_status(400)
      end
    end
  end

end