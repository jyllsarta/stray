require 'rails_helper'

# グローバルなヘルパーのテスト
RSpec.describe ApplicationController, type: :model do
  let(:controller){ ApplicationController.new }
  describe "#current_user" do
    subject { controller.current_user }
    before do
      allow(controller).to receive(:render)
    end
    context "with no token" do
      before do
        allow(controller).to receive_message_chain(:request, :headers).and_return( {"X-AccessToken": ""} )
      end
      it "raises error" do
        expect{subject}.to raise_error ApplicationController::NoToken
      end
    end
    context "with correct token" do
      let!(:user){ create(:user) }
      before do
        token = User::AccessToken.generate(user)
        allow(controller).to receive_message_chain(:request, :headers).and_return( {"X-AccessToken" => token} )
      end
      it "returns user object" do
        expect(subject).to eq(user)
      end
    end
    context "with invalid token" do
      let!(:user){ create(:user) }
      before do
        token = User::AccessToken.generate(user)
        allow(controller).to receive_message_chain(:request, :headers).and_return( {"X-AccessToken" => token + "something error string"} )
      end
      it "raises error" do
        expect{subject}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
