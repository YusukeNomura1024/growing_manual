class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :bookmarks , dependent: :destroy
  has_many :bookmarked_manuals, through: :bookmarks, source: :manual
  has_many :manuals   , dependent: :destroy
  has_many :reviews   , dependent: :destroy
  has_many :messages  , dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :memos     , dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  has_many :tags      , dependent: :destroy


  attachment :image


  validates :email              , presence: true, uniqueness: true
  validates :full_name          , presence: true, length: { maximum: FULL_NAME_MAXIMUM_LENGTH = 20}
  validates :pen_name           , presence: true, length: { maximum: PEN_NAME_MAXIMUM_LENGTH = 20}, uniqueness: true
  validates :encrypted_password , presence: true

  def bookmarked_count
    manuals.preload(:bookmarked_users).inject(0) do |result, manual|
      result + manual.bookmarked_users.size
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

  def active_for_authentication?
    super && (self.is_active == true)
  end

  # 管理者が会員のマニュアルを削除したことを連絡するメソッド
  def create_message_deleted_user_manual!(deleted_manual_title)
    message = Message.new(
        user_id: self.id,
        comment: "あなたのマニュアル「#{deleted_manual_title}」は規約に違反すると判断し、削除いたしました",
        is_replied: true,
        type: "from_admin",
      )
    if message.valid?
      message.save
      self.create_notification_from_admin!
    end
  end

  #管理者が会員にメッセージを送ったときに通知が作成されるメソッド
  def create_notification_from_admin!
    notification = self.passive_notifications.new(
        visited_id: self.id,
        is_checked: false,
        type: "from_admin"
      )
    notification.save if notification.valid?
  end

end
