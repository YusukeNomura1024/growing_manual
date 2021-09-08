class Memo < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :memo_links, dependent: :destroy

end
