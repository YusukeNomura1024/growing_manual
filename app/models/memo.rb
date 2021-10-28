class Memo < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :memo_links, dependent: :destroy

  validates :category_id, presence: false
  with_options presence: true do
    validates :user_id
    validates :name
  end

  def self.search(keyword, category_id)
    where(["name like? OR description like? OR category_id=?", "%#{keyword}%", "%#{keyword}%", "#{category_id}"])
  end

end
