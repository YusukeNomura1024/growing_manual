FactoryBot.define do
  factory :tag_map do
    manual_id { FactoryBot.create(:manual).id }
    tag_id { FactoryBot.create(:tag).id }
  end
end