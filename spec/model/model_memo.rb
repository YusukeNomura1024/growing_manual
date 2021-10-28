require 'rails_helper'

RSpec.describe Memo, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    let!(:memo) { FactoryBot.build(:memo) }
    context "通常の保存" do
      it '保存される' do
        expect(memo).to be_valid
      end
    end
    describe "category_idについて" do
      it 'category_idが空白でも保存される' do
        memo.category_id = nil
        expect(memo).to be_valid
      end
    end
    describe "user_idについて" do
      context '空白の場合' do
        it '空白では保存されず、エラーメッセージ「を入力してください」が含まれる' do
          memo.user_id = nil
          expect(memo).to be_invalid
          expect(memo.errors[:user_id]).to include("を入力してください")
        end
      end
    end
    describe "nameについて" do
      context '空白の場合' do
        it '空白では保存されず、エラーメッセージ「を入力してください」が含まれる' do
          memo.name = nil
          expect(memo).to be_invalid
          expect(memo.errors[:name]).to include("を入力してください")
        end
      end
    end
  end
  describe '実際に削除してみる' do
    let!(:memo) { FactoryBot.create(:memo) }
    context '削除を実行した場合' do
      it '検索しても見つからない' do
        memo_id = memo.id
        memo.destroy
        expect{Memo.find(memo_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
      it '検索結果が０件' do
        memo_id = memo.id
        expect(Memo.where(id: memo_id).count).to eq 1
        memo.destroy
        expect(Memo.where(id: memo_id).count).to eq 0
      end
      it 'レコード数が１つ減っている' do
        count = Memo.all.count
        memo.destroy
        expect(Memo.all.count).to eq(count - 1)
      end
      context 'memoがmemo_linkに紐づけされていた場合' do
        it '紐づいているmemo_linkも一緒に削除される' do
          memo_link = FactoryBot.create(:memo_link, memo_id: memo.id)
          memo_link_id = memo_link
          expect(MemoLink.where(id: memo_link_id).count).to eq 1
          memo.destroy
          expect(MemoLink.where(id: memo_link_id).count).to eq 0
        end
      end

    end
  end
  describe 'アソシエーションのテスト' do
    describe 'userとの関係性' do
      it 'N:1である' do
        expect(Memo.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    describe 'categoryとの関係性' do
      it 'N:1である' do
        expect(Memo.reflect_on_association(:category).macro).to eq :belongs_to
      end
    end
    describe 'memo_linkとの関係性' do
      it '1:Nである' do
        expect(Memo.reflect_on_association(:memo_links).macro).to eq :has_many
      end
    end
  end
  describe 'メソッドのテスト' do
    context 'searchメソッド' do
      before :each do
        FactoryBot.create(:memo, name: "name1", description: "description1")
        FactoryBot.create(:memo, name: "name2", description: "description2")
      end
      context 'キーワードが名前に該当する場合' do
        it '該当するデータは2つである' do
          keyword = "name"
          expect(Memo.search(keyword, nil).count).to eq 2
        end
        it '該当するデータは1つである' do
          keyword = "name1"
          expect(Memo.search(keyword, nil).count).to eq 1
        end
        it '該当するデータがない' do
          keyword = "name3"
          expect(Memo.search(keyword, nil).count).to eq 0
        end
      end
      context 'キーワードが説明文に該当する場合' do
        it '該当するデータは2つである' do
          keyword = "description"
          expect(Memo.search(keyword, nil).count).to eq 2
        end
        it '該当するデータは1つである' do
          keyword = "description1"
          expect(Memo.search(keyword, nil).count).to eq 1
        end
        it '該当するデータがない' do
          keyword = "description3"
          expect(Memo.search(keyword, nil).count).to eq 0
        end
      end
    end
  end
end


# 動作確認のための記述
describe '四則演算' do
  context '足し算' do
    it '1 + 1 は 2 になる' do
      expect(1 + 1).to eq 2
    end
  end
end