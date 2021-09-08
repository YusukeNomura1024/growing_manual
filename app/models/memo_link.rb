class MemoLink < ApplicationRecord
  belongs_to :procedure
  belongs_to :memo
end
