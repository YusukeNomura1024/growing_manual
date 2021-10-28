require 'rails_helper'

RSpec.describe Category, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な内容の場合は保存されるか" do
      expect(FactoryBot.build(:category)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      category = Category.new(name: '')
      expect(category).to be_invalid
      expect(category.errors[:name]).to include("を入力してください")
    end
  end
  context "文字数のバリデーションチェック" do
    it "nameが21文字以上の場合にバリデーションチェックされエラーメッセージが返ってきているか" do
      category = FactoryBot.build(:category, name: Faker::Lorem.characters(number: 21))
      expect(category).to be_invalid
      expect(category.errors[:name]).to include("は20文字以内で入力してください")
    end
  end
  describe "一意性のバリデーションチェック" do
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }
    context '同じユーザーが既存のnameのcategoryを保存する場合' do
      it "バリデーションチェックされエラーメッセージが返る" do
        FactoryBot.create(:category, name: "name", user_id: user1.id)
        category2 = FactoryBot.build(:category, name: "name", user_id: user1.id)
        expect(category2).to be_invalid
        expect(category2.errors[:name]).to include("はすでに存在します")
      end
    end
    context '異なるユーザーが既存のnameのcategoryを保存する場合' do
      it "保存できる" do
        FactoryBot.create(:category, name: "name", user_id: user1.id)
        category2 = FactoryBot.build(:category, name: "name", user_id: user2.id)
        expect(category2).to be_valid
      end
    end
  end
end

