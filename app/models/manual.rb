class Manual < ApplicationRecord
  belongs_to :user

  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :procedures, -> {order(position: :asc)}, dependent: :destroy

  attachment :image

  def create_notification_bookmark!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and manual_id = ? and type = ? ", current_user.id, user_id, id, 'bookmarking'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        manual_id: id,
        visited_id: user_id,
        type: 'bookmarking'
      )
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