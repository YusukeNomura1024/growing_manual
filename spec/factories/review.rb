FactoryBot.define do
  factory :review do
    user_id { FactoryBot.create(:user).id }
    manual_id { FactoryBot.create(:manual).id }
    rate { Faker::Number.between(from: 0, to: 5) }
  end
end