require 'rails_helper'

describe '[STEP1] ユーザログイン後のテスト' do
  before do
    @user = FactoryBot.create(:user)
    @manual = FactoryBot.create(:manual, user_id: @user.id)
    visit manual_path(@manual)
  end

  describe '表示内容の確認' do
    it 'URLが正しい' do
      expect(current_path).to eq "/manuals/#{@manual.id}"
    end
  end
end