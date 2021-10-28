FactoryBot.define do
  factory :notification do
    visited_id { FactoryBot.create(:user).id }

    factory :notification__bookmarking do
      visitor_id { FactoryBot.create(:user).id }
      manual_id { FactoryBot.create(:manual).id }
      type { "bookmarking" }
    end
    factory :notification__reviewing do
      visitor_id { FactoryBot.create(:user).id }
      review_id { FactoryBot.create(:review).id }
      type { "reviewing" }
    end
    factory :notification__from_admin do
      visitor_id { FactoryBot.create(:user).id }
      type { "from_admin" }
    end
  end
end