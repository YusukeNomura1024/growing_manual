FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    full_name {Faker::Name.name}
    pen_name {Faker::Lorem.characters(number: 5)}
    password { "hogehogehoge" }

  end
end