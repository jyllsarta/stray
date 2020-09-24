require 'rails_helper'

RSpec.describe "User::Item", type: :request do

  describe "POST /users/:user_id/user_items/:user_item_id/rank_up" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:item){ create(:item) }
    let!(:user_item){ create(:user_item, user: user, item: item, rank: 3) }
    let(:do_post) { post user_user_item_rank_up_path(user_id: -1, user_item_id: user_item.item_id) + ".json", params: params }

    context "sufficient coin" do
      before do
        # 厳密なやつはmodelでテストするので適当に通るようにする
        user.status.add_coin!(10000)
        user.status.reload
      end
      let(:params) do
        {
          count: 1
        }
      end
      subject do
        do_post
        response
      end

      it "returns formatted hash" do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     after_coin: Integer,
                                                     after_rank: Integer,
                                                     item_id: Integer,
                                                 }
                                             )
      end
    end

    # 厳密なテストはmodelに書くのでエラーキャッチだけテスト
    context "insufficient coin" do
      let(:params) do
        {
            count: 1
        }
      end
      subject do
        do_post
        response
      end
      it 'returns events list' do
        expect(subject).to have_http_status(400)
      end
    end
  end
end