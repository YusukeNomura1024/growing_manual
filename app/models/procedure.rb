class Procedure < ApplicationRecord
  has_many :memo_links, dependent: :destroy
  belongs_to :manual

  acts_as_list scope: :manual

  validates :manual_id, presence: true
  validates :title, presence: true, length: { maximum: TITLE_MAXIMUM_LENGTH = 20 }

end
