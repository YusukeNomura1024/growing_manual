FactoryBot.define do
  factory :bookmark do
    user_id { FactoryBot.create(:user).id }
    manual_id {FactoryBot.create(:manual).id}
  end
end