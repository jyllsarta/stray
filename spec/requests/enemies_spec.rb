require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Enemies", type: :request do

  describe "GET /enemies/" do
    include_context("stub_current_user")
    let!(:enemy ) { create(:enemy, :with_card, :with_skill) }
    let!(:dungeon){ create(:dungeon) }
    let!(:item){ create(:item, id: 1) unless Item.exists?(id: 1) }
    let!(:item2){ create(:item, id: 2) unless Item.exists?(id: 2) }
    let!(:user){ User.create }
    let(:do_get) { get enemies_path + ".json" }
    let(:params) do
      {}
    end

    subject do
      do_get
      response
    end

    context "succeeds" do
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     enemies: Array,
                                                 }
                                             )
      end
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)&.[]('enemies')&.select{|x| x['id'] == enemy.id}&.first).to match_json_expression(
                                                 {
                                                     id: Integer,
                                                     name: String,
                                                     hp: Integer,
                                                     rank: Integer,
                                                     cards: [
                                                         {
                                                             name:String,
                                                             power: Integer,
                                                             tech: Integer
                                                         },
                                                         {
                                                             name:String,
                                                             power: Integer,
                                                             tech: Integer
                                                         },
                                                         {
                                                             name:String,
                                                             power: Integer,
                                                             tech: Integer
                                                         },
                                                         {
                                                             name:String,
                                                             power: Integer,
                                                             tech: Integer
                                                         }
                                                     ],
                                                     skills: [
                                                         {
                                                             id: Integer,
                                                             name: String,
                                                             description: String,
                                                             reusable: Boolean,
                                                             is_defence: Boolean,
                                                             cost: Integer,
                                                             effect1_category: String,
                                                             effect1_to_self: Boolean,
                                                             effect1_value: Integer,
                                                             effect2_category: String,
                                                             effect2_to_self: Boolean,
                                                             effect2_value: Integer,
                                                             effect3_category: String,
                                                             effect3_to_self: Boolean,
                                                             effect3_value: Integer,
                                                         }
                                                     ],
                                                 }
                                             )
      end
    end
  end

  describe "POST /enemies/:id/engage" do
    include_context("stub_current_user")
    let!(:enemy ) { create(:enemy) }
    let(:user){ User.create }
    let(:do_post) { post enemy_engage_path(enemy_id: enemy.id)}
    let(:params) do
      {}
    end
    subject do
      do_post
      response
    end

    before do
      Rails.cache.delete("quest:#{user.id}")
    end
    context "succeeds" do
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     playerHp: Integer,
                                                     enemyName: String,
                                                     enemyHp: Integer,
                                                     playerCards: Array,
                                                     playerSkills: Array,
                                                     enemyCards: Array,
                                                     enemySkills: Array,
                                                     seed: Integer,
                                                 }
                                             )
      end
    end
  end

  describe "POST /enemies/:id/showdown" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let!(:enemy ) { create(:enemy) }
    let(:do_post) { post enemy_showdown_path(enemy_id: enemy.id), params: params }
    let(:params) do
      {
          operation_history: "[]"
      }
    end

    before do
      QuestBattle.new(user).engage!(enemy.id)
      allow_any_instance_of(QuestBattle).to receive(:showdown!).and_return({'isWin'=>true, 'isDraw'=>false})
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
                                                     success: Boolean,
                                                     isWin: Boolean,
                                                     isDraw: Boolean,
                                                 }
                                             )
      end
    end
  end
end