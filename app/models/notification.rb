class Notification < ApplicationRecord
  belongs_to :manual,   optional: true
  belongs_to :visitor,  class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited,  class_name: 'User', foreign_key: 'visited_id'
  belongs_to :review,  optional: true

  self.inheritance_column = :_type_disabled

  enum type: { bookmarking: 0, reviewing: 1, from_admin: 2 }

  with_options presence: true do
    validates :visited_id
    validates :type
  end
  validates :manual_id, presence: true, if: :is_type_bookmarking?
  validates :review_id, presence: true, if: :is_type_reviewing?
  validates :is_checked, inclusion: { in: [true, false] }

  def is_type_bookmarking?
    type == 'bookmarking'
  end

  def is_type_reviewing?
    type == 'reviewing'
  end


end
