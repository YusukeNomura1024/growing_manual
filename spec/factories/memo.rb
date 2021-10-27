FactoryBot.define do
  factory :memo do
    user_id { FactoryBot.create(:user).id }
    category_id {FactoryBot.create(:category).id}
    name {Faker::Lorem.characters(number: 20)}
    description {Faker::Lorem.characters(number: 200)}
    url { Faker::Internet.url }
    code { Faker::Lorem.characters(number: 200) }
  end
end