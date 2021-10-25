FactoryBot.define do
  factory :category do
    name { Faker::Lorem.characters(number:5) }
    user_id {FactoryBot.create(:user).id}
  end
end