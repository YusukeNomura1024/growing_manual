class Review < ApplicationRecord
  belongs_to :user
  belongs_to :manual
  has_many :messages, dependent: :destroy
end
