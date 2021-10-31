require 'rails_helper'

RSpec.describe Public::ProceduresController, type: :controller do
  describe "#index" do
    # 正常なレスポンスか？
    it "responds successfully" do
      @manual = FactoryBot.create(:manual)
      get :index
      expect(response).to be_success

    end
  end
end