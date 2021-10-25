FactoryBot.define do
  factory :manual do
    user_id {FactoryBot.create(:user).id}
    title {Faker::Lorem.characters(number: 20)}
    description {Faker::Lorem.characters(number: 200)}
  end
end