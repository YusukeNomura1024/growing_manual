class Procedure < ApplicationRecord
  has_many :memo_links, dependent: :destroy
  belongs_to :manual
end
