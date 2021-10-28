FactoryBot.define do
  factory :message do
    user_id { FactoryBot.create(:user).id }
    comment {Faker::Lorem.characters(number: 50)}

    factory :message__type_contact do
      manual_id {nil}
      review_id {nil}
      type { "contact" }
    end

    factory :message__type_violation_report do
      type { "violation_report" }

      factory :message__target_manual do
        manual_id  { FactoryBot.create(:manual).id }
      end

      factory :message__target_review do
        review_id  { FactoryBot.create(:review).id }
      end

    end

    factory :message__type_from_admin do
      manual_id {nil}
      review_id {nil}
      type { "from_admin" }
    end

  end

end