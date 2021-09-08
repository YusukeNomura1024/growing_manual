class Message < ApplicationRecord
  belongs_to :user
  belongs_to :manual, optional: true
  belongs_to :review, optional: true

  enum type: { contact: 0, violation_report: 1, from_admin: 2 }
end
