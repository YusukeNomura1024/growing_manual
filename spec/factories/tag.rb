FactoryBot.define do
  factory :tag do
    user_id { FactoryBot.create(:user).id }
    name { Faker::Lorem.characters(number: 20) }
  end
end