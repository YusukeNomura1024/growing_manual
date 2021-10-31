require 'rails_helper'

RSpec.describe Public::ManualsController, type: :controller do
  describe "ログイン状態"
    before do
      @user = FactoryBot.create(:user)
    end
    describe "#index" do
    # 正常なレスポンスか？
    it "responds successfully" do
      # 「@user」としてログイン
      login_user @user

      get :index
      expect(response).to be_success

    end
  end
end