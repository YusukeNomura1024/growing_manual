class Category < ApplicationRecord
  belongs_to :user
  has_many :memos, dependent: :nullify

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: { scope: :user_id }

end
