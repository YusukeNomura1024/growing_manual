class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :manual

  validates :user_id, uniqueness: { scope: :manual_id }
end
