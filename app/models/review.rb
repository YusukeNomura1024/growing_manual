class Review < ApplicationRecord
  belongs_to :user
  belongs_to :manual
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def star
    case rate
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
