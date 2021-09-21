class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_manuals, through: :bookmarks, source: :manual
  has_many :manuals, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :memos, dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  has_many :tags, dependent: :destroy


  attachment :image

  def bookmarked_count
    manuals.inject(0) do |result, manual|
      result + manual.bookmarked_users.count
    end
  end

  def passive_notifications_count
    passive_notifications.where.not(is_checked: true).count
  end

  def status_text
    if is_active
      "有効"
    else
      "無効"
    end
  end



end
