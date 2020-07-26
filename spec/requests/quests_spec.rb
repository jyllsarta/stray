require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Quest", type: :request do
  describe "GET /quests" do
    include_context("stub_current_user")
    let(:user){ create(:user) }
    let(:do_get) { get quests_path + ".json" }
    let(:params) do
      {}
    end
    subject do
      do_get
      response
    end

    # ロジックでQuest.all しているので、スタブでできたレコードを意識したくない
    before do
      Quest.delete_all
    end

    context "succeeds" do
      let!(:quest) { create(:quest) }
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     quests: [
                                                         {
                                                             id: Integer,
                                                             name: String,
                                                             description: String,
                                                             enemy_count: Integer,
                                                             won_enemy_count: Integer
                                                         }
                                                     ]
                                                 }
                                             )
      end

      context "親クエストをクリアしていない場合は一覧に表示しない" do
        let!(:quest) { create(:quest) }
        let!(:child_quest) { create(:quest, parent_quest_id: quest.id) }
        let!(:enemy){ create(:enemy, quest: quest) }
        context "クリアしてないとき" do
          it '子クエストは配信されない' do
            expect(subject).to have_http_status(200)
            expect(JSON.parse(response.body)['quests'].map{|x| x['id']}.include?(child_quest.id)).to eq(false)
          end
        end
        context "クリアしてるとき" do
          let!(:user_won_enemy){ create(:user_won_enemy, user: user, enemy: enemy) }
          it '子クエストは配信される' do
            expect(subject).to have_http_status(200)
            expect(JSON.parse(response.body)['quests'].map{|x| x['id']}.include?(child_quest.id)).to eq(true)
          end
        end
      end
    end
  end
end