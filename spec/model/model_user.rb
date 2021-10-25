require 'rails_helper'

RSpec.describe Category, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な内容の場合は保存されるか" do
      expect(FactoryBot.build(:user)).to be_valid
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