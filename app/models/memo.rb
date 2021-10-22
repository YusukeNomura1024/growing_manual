class Memo < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :memo_links, dependent: :destroy

  def self.search(keyword, category_id)
    where(["name like? OR description like? OR category_id=?", "%#{keyword}%", "%#{keyword}%", "#{category_id}"])
  end

end
