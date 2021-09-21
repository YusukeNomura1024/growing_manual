class Notification < ApplicationRecord
  belongs_to :manual,   optional: true
  belongs_to :visitor,  class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited,  class_name: 'User', foreign_key: 'visited_id'
  belongs_to :review,  optional: true

  self.inheritance_column = :_type_disabled

  enum type: { bookmarking: 0, reviewing: 1, from_admin: 2 }



end
