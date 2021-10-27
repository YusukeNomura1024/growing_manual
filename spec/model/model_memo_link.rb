require 'rails_helper'

RSpec.describe MemoLink, "モデルに関するテスト", type: :model do
  let!(:memo_link) { FactoryBot.build(:memo_link) }
  describe '実際に保存してみる' do
    it "有効な内容の場合は保存されるか" do
      expect(memo_link).to be_valid
    end
    context 'procedure_idが空の場合' do
      it "バリデーションエラーになり、空白のエラーメッセージが表示される" do
        memo_link.procedure_id = nil
        expect(memo_link).to be_invalid
        expect(memo_link.errors[:procedure_id]).to include("を入力してください")
      end
    end
    context 'memo_idが空の場合' do
      it "バリデーションエラーになり、空白のエラーメッセージが表示される" do
        memo_link.memo_id = nil
        expect(memo_link).to be_invalid
        expect(memo_link.errors[:memo_id]).to include("を入力してください")
      end
    end
  end
  describe 'アソシエーションのテスト' do
    describe 'procedureモデルとの関係性' do
      it 'N:1となっている' do
        expect(MemoLink.reflect_on_association(:procedure).macro).to eq :belongs_to
      end
    end
    describe 'memoモデルとの関係性' do
      it 'N:1となっている' do
        expect(MemoLink.reflect_on_association(:memo).macro).to eq :belongs_to
      end
    end
  end
  describe 'メソッドのテスト' do
    describe 'is_unique?の機能チェック' do
      it '重複するレコードがない場合trueになる' do
        expect(memo_link.is_unique?).to be_truthy
      end
      it '重複するレコードがある場合falseになる' do
        memo_link.save
        expect(memo_link.is_unique?).to be_falsey
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