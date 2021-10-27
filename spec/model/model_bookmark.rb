require 'rails_helper'

RSpec.describe Bookmark, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    context "有効な内容の場合" do
      let!(:bookmark) { FactoryBot.build(:bookmark) }
      it '保存される' do
        expect(bookmark).to be_valid
      end
    end
    context '一つのmanualに対して同じユーザーがbookmarkした場合' do
      user = FactoryBot.create(:user)
      manual = FactoryBot.create(:manual)
      bookmark = Bookmark.new(user_id: user.id, manual_id: manual.id)
      bookmark_clone = Bookmark.new(user_id: user.id, manual_id: manual.id)
      it '保存されない' do
        expect(bookmark.save).to be_truthy
        expect(bookmark_clone).to be_invalid
      end
      it 'Userはすでに存在しますと表示される' do
        expect(bookmark_clone.errors[:user_id]).to include("はすでに存在します")
      end
    end
    context 'user_idが空白の場合' do
      it 'バリデーションエラーになり、空白のメッセージが表示される' do
        bookmark = FactoryBot.build(:bookmark)
        bookmark.user_id = nil
        expect(bookmark).to be_invalid
        expect(bookmark.errors[:user_id]).to include("を入力してください")
      end
    end
    context 'manual_idが空白の場合' do
      it 'バリデーションエラーになり、空白のメッセージが表示される' do
        bookmark = FactoryBot.build(:bookmark)
        bookmark.manual_id = nil
        expect(bookmark).to be_invalid
        expect(bookmark.errors[:manual_id]).to include("を入力してください")
      end
    end
  end
  describe 'アソシエーションのテスト' do
    describe 'userモデルとの関係性' do
      it 'N:1となっている' do
        expect(Bookmark.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    describe 'manualモデルとの関係性' do
      it 'N:1となっている' do
        expect(Bookmark.reflect_on_association(:manual).macro).to eq :belongs_to
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