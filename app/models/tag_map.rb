class TagMap < ApplicationRecord
  belongs_to :manual
  belongs_to :tag

  validates :manual_id, presence: true
  validates :tag_id, presence: true
end
