class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy, foreign_key: 'tag_id'
  has_many :manuals, through: :tag_maps
  belongs_to :user

  validates :user_id, presence: true
  validates :name   , presence: true, length: {maximum: 20}

end
