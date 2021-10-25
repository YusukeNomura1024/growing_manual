require 'rails_helper'

RSpec.describe Category, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な内容の場合は保存されるか" do
      expect(FactoryBot.build(:category)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      category = Category.new(name: '')
      expect(category).to be_invalid
      expect(category.errors[:name]).to include("を入力してください")
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