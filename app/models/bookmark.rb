class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :manual

  validates :user_id, uniqueness: { scope: :manual_id }
  with_options presence: true do
    validates :user_id
    validates :manual_id
  end
end
