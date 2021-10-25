class Category < ApplicationRecord
  belongs_to :user
  has_many :memos, dependent: :nullify

  validates :name, presence: true, length: { maximum: 10 }

end
