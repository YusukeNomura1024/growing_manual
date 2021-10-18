class Manual < ApplicationRecord
  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_many :reviews, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :procedures, -> {order(position: :asc)}, dependent: :destroy

  attachment :image


  def bookmarked_by?(your_id)
    bookmarks.where(user_id: your_id).exists?
  end


  def average_rate
    rate_hash = Review.group(:manual_id).average(:rate)
    if rate_hash[self.id].nil?
      0
    else
      BigDecimal(rate_hash[self.id].to_s).floor(2).to_f
    end
  end

  def average_star
    case self.average_rate.floor
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

  def create_notification_bookmark!(current_user)
    #ブックマークは１つのマニュアルに１回のみ
    temp = Notification.where(["visitor_id = ? and visited_id = ? and manual_id = ? and type = ? ", current_user.id, self.user_id, self.id, 'bookmarking'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        manual_id: self.id,
        visited_id: self.user_id,
        type: 'bookmarking'
      )
      #自分のマニュアルに対する、お気に入りの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.is_checked = true
      end
      notification.save if notification.valid?
    end
  end


  def create_notification_review!(current_user, review_id, visited_id)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and manual_id = ? and type = ? ", current_user.id, visited_id, self.id, 'reviewing'])
    #評価は1つのマニュアルに１回のみ（複数回可能にする場合は、if temp.blank?を外す）
    if temp.blank?
      notification = current_user.active_notifications.new(
          manual_id: self.id,
          review_id: review_id,
          visited_id: visited_id,
          type: 'reviewing'
        )
      #自分のマニュアルに対する、評価の場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.is_checked = true
      end
      notification.save if notification.valid?
    end
  end


  def save_manuals(savemanual_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - savemanual_tags
    new_tags = savemanual_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      manual_tag = Tag.find_or_create_by(name: new_name, user_id: self.user_id)
      self.tags << manual_tag
    end
  end

  def self.search(keyword)
    where(["title like? OR description like?", "%#{keyword}%", "%#{keyword}%"])
  end

  def status_text
    case status
    when true
      '公開中'
    when false
      '非公開'
    end
  end

  def status_style
    case status
    when true
      'color:#19b5d1;'
    when false
      'color:gray;'
    end
  end

end