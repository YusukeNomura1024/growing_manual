FactoryBot.define do
  factory :procedure do
    manual_id { FactoryBot.create(:manual).id }
    title {Faker::Lorem.characters(number: 20)}
  end
end