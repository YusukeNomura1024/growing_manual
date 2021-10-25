require 'rails_helper'

RSpec.describe Manual, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な内容の場合は保存されるか" do
      expect(FactoryBot.build(:manual)).to be_valid
    end
    it "説明の文字数が２００文字を超える場合は保存されないか" do
      manual = FactoryBot.build(:manual)
      manual.description = Faker::Lorem.characters(number: 201)
      expect(manual).to be_invalid
      expect(manual.errors[:description]).to include("は200文字以内で入力してください")
    end
  end
  context "空白のバリデーションチェック" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      manual = FactoryBot.build(:manual)
      manual.title = ""
      expect(manual).to be_invalid
      expect(manual.errors[:title]).to include("を入力してください")
    end
    it "statusが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      manual = FactoryBot.build(:manual)
      manual.status = ""
      expect(manual).to be_invalid
      expect(manual.errors[:status]).to include("は一覧にありません")
    end
    it "statusはデフォルトがfalseか？" do
      expect(FactoryBot.build(:manual).status).to eq false
    end
  end
end

describe '四則演算' do
  context '足し算' do
    it '1 + 1 は 2 になる' do
      expect(1 + 1).to eq 2
    end
  end
end