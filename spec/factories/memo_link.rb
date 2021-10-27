FactoryBot.define do
  factory :memo_link do
    procedure_id { FactoryBot.create(:procedure).id }
    memo_id {FactoryBot.create(:memo).id}
  end
end