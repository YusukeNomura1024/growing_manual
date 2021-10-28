class Procedure < ApplicationRecord
  has_many :memo_links, dependent: :destroy
  belongs_to :manual

  acts_as_list scope: :manual

  validates :manual_id, presence: true
  validates :title, presence: true
  validates :position, presence: true, numericality: {only_integer: true, greater_than: 0}

end
