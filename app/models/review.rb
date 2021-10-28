class Review < ApplicationRecord
  belongs_to :user
  belongs_to :manual
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :rate, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 0}


  def star
    case rate
    when 0
      "☆☆☆☆☆"
    when 1
      "★☆☆☆☆"
    when 2
      "★★☆☆☆"
    when 3
      "★★★☆☆"
    when 4
      "★★★★☆"
    when 5
      "★★★★★"
    end
  end
end
