class MemoLink < ApplicationRecord
  belongs_to :procedure
  belongs_to :memo

  validates :procedure_id, presence: true
  validates :memo_id, presence: true

  def is_unique?
    search_memo_link = MemoLink.find_by(memo_id: self.memo_id, procedure_id: self.procedure_id)
    search_memo_link.nil?
  end

end
