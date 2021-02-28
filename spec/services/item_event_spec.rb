require 'rails_helper'

RSpec.describe ItemEvent, type: :model do
  before do
    # Item は IDにロジックが食い込んでるのでtest dbに適当に溜め込むわけにはいかない
    Item.delete_all
    Item.reset_cache!
  end
  let(:user){create(:user)}
  let!(:status){create(:user_status, user: user)}
  let(:event){ ItemEvent.new(rank) }
  let(:rank){ 0 }
  let!(:item1){create(:item, id: 1, rarity: 1)}
  let!(:item2){create(:item, id: 2, rarity: 2)}
  let!(:item3){create(:item, id: 3, rarity: 3)}
  let!(:item4){create(:item, id: 4, rarity: 4)}
  let!(:item5){create(:item, id: 5, rarity: 5)}

  describe "#type" do
    subject { event.type }
    it "returns 'item'" do
      expect(subject).to eq("item")
    end
  end
  describe "#detail" do
    before do
      event.execute(user)
    end
    subject { event.detail }
    it "returns formatted hash" do
      expect(subject).to match_json_expression(
                             {
                                 id: Integer,
                                 rank: Integer
                             }
                         )
    end
  end
  describe "#logs" do
    before do
      event.execute(user)
    end
    subject { event.logs }
    it "returns formatted logs" do
      expect(subject).to match_json_expression(
                             [
                                 at: Integer,
                                 message: String
                             ]
                         )
    end
  end
  describe "#execute!" do
    subject do
      event.execute(user)
      changed_items = user.status.memoized_items_hash.values.select{ |item| item.changed? || !item.persisted? }
      User::Item.import!(changed_items, on_duplicate_key_update: [:rank])
    end
    context "アイテムを何も持ってない時" do
      it "アイテムが何かしら一個増える" do
        expect{subject}.to change(user.items, :count).by(1)
      end
      it "ログメッセージは「拾った」" do
        subject
        expect(event.logs[0][:message].include?("拾った")).to eq(true)
      end
      
      context "achievement" do
        before do
          allow(user).to receive_message_chain(:achievement_logger, :post)
        end
        it "posts achievement" do
          subject
          expect(user).to have_received(:achievement_logger)
        end
      end
    end

    context "持ってるアイテムが選ばれた時" do
      context "ランクがまだ最大になっていなかったら" do
        let!(:user_item){ create(:user_item, user: user, item_id: event.detail[:id], rank: 1)}
        before do
          allow_any_instance_of(ItemEvent).to receive(:amount).and_return(2)
        end
        it "そいつのランクがamount分増える" do
          expect(user.items.find(user_item.id).rank).to eq(1)
          subject
          expect(user.items.find(user_item.id).rank).to eq(1 + 2)
          expect(user.status.coin).to eq(0)
        end
        it "まとめて強化ログを吐く" do
          subject
          expect(event.logs[0][:message].include?("まとめて")).to eq(true)
        end
      end
      context "それがすでに最大ランクだったら" do
        let!(:user_item){ create(:user_item, user: user, item_id: event.detail[:id], rank: Constants.item.default_max_rank)}
        it "ランクは上昇せずコインがもらえる" do
          subject
          expect(user.items.find(user_item.id).rank).to eq(Constants.item.default_max_rank)
          expect(user.status.coin).to eq(1) # rank / 3 + 1 の 1
        end
      end
      context "それがすでに最大ランクを超えていても" do
        let!(:user_item){ create(:user_item, user: user, item_id: event.detail[:id], rank: Constants.item.default_max_rank + 100)}
        it "ランクは下がったりしない" do
          subject
          expect(user.items.find(user_item.id).rank).to eq(Constants.item.default_max_rank + 100)
        end
      end
      context "amountがランク最大値にかぶるような値になった時" do
        let!(:user_item){ create(:user_item, user: user, item_id: event.detail[:id], rank: Constants.item.default_max_rank - 1)}
        before do
          allow_any_instance_of(ItemEvent).to receive(:amount).and_return(3)
        end
        it "ランク最大値まで上昇し、それ以上は捨てられる" do
          subject
          expect(user.items.find(user_item.id).rank).to eq(Constants.item.default_max_rank)
        end
        it "ログメッセージは+1だけ" do
          subject
          expect(event.logs[0][:message].include?("まとめて")).to eq(false)
        end

        context "ランク最大値付近でも上限突破していたら" do
          before do
            allow_any_instance_of(ItemEvent).to receive(:max_rank).and_return(150)
          end
          it "新しい上限までは取得できる" do
            subject
            expect(user.items.find(user_item.id).rank).to eq(102)
          end
        end
      end
    end

    context "とても高いランクのイベントが発生した時" do
      let(:rank){100000}
      it "正常にランダムアイテムが付与される" do
        subject
        # このspec内ではアイテムIDは 1 ~ 5 しか存在しない
        expect((1..5).include?(event.instance_variable_get("@item_id"))).to be_truthy
      end

      it "ランダムアイテムのランク + ベースランクの合計値が元ランク+10の範囲にある" do
        subject
        user_item = user.items.reload.first
        expect((rank..(rank+Constants.item.higher_rank_jitter)).include?(user_item.item_rank)).to eq(true)
      end

      it "なんらか強化したメッセージが入っている" do
        subject
        expect(event.logs[0][:message].include?("強化した")).to eq(true)
      end

      context "もう全種類の十分に強化されたアイテムを持ってる時" do
        before do
          user.items.create(item_id: item1.id, rank: rank + Constants.item.higher_rank_jitter)
          user.items.create(item_id: item2.id, rank: rank + Constants.item.higher_rank_jitter)
          user.items.create(item_id: item3.id, rank: rank + Constants.item.higher_rank_jitter)
          user.items.create(item_id: item4.id, rank: rank + Constants.item.higher_rank_jitter)
          user.items.create(item_id: item5.id, rank: rank + Constants.item.higher_rank_jitter)
        end
        it "アイテムはコインに変換されてて、コイン量はキャップされている" do
          expect{subject}.to change(user.status, :coin).by(100)
          expect(event.logs[0][:message].include?("コインに変換した")).to eq(true)
        end  
      end
    end
  end
  describe "#consume_time" do
    subject { event.consume_time(user) }
    it "returns default value" do
      expect(subject).to eq(Constants.default_event_interval_seconds)
    end

    context "has relic" do
      before do
        allow(user.status).to receive(:event_wait_reduction_seconds).and_return(5)
      end
      it "returns minimum value" do # テスト環境なので5 → 4 で下限に到達
        expect(subject).to eq(Constants.default_event_interval_seconds - 5)
      end
    end
  end
  describe "#amount" do
    before do
      event.execute(user)
    end
    subject { event.send(:amount) }

    context "1" do
      before do
        status.update!(velocity: 100)
      end
      it "returns 1" do
        expect(subject).to eq(1)
      end
    end
    context "1" do
      before do
        status.update!(velocity: 199)
      end
      it "returns 1" do
        expect(subject).to eq(1)
      end
    end
    context "2" do
      before do
        status.update!(velocity: 200)
      end
      it "returns 2" do
        expect(subject).to eq(2)
      end
    end
    context "3" do
      before do
        status.update!(velocity: 300)
      end
      it "returns 2" do
        expect(subject).to eq(3)
      end
    end
  end  
end
