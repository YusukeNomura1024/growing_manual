class Message < ApplicationRecord
  belongs_to :user
  belongs_to :manual, optional: true
  belongs_to :review, optional: true
  self.inheritance_column = :_type_disabled

  enum type: { contact: 0, violation_report: 1, from_admin: 2 }

  with_options presence: true do
    validates :user_id
    validates :comment
    validates :type
  end

  validates :comment, length: {maximum: 100}

  scope :contact, -> {where(type: 'contact')}
  scope :violation_report, -> {where(type: 'violation_report')}
  scope :not_reply, -> {where.not(is_replied: true)}

  def violation_report?
    if self.type == 'violation_report'
      true
    else
      false
    end
  end

  def report_target
    if violation_report?
      if !self.manual_id.nil?
        target_manual = self.manual
        "マニュアル[#{target_manual.title}]"
      elsif !self.review_id.nil?
        target_review = self.review
        target_user = target_review.user
        "#{target_user.pen_name}のレビュー"
      end
    else
      nil
    end
  end

  def report_target_link
    if !self.manual_id.nil?
      target_manual = Manual.find(self.manual_id)
      "/manuals/#{target_manual.id}"
    elsif !self.review_id.nil?
      target_review = Review.find(self.review_id)
      manual = Manual.find(target_review.manual_id)
      "/manuals/#{manual.id}/reviews"
    else
      nil
    end

  end

  # 管理者用メソッド
  def report_target_admin_link
    if !self.manual_id.nil?
      target_manual = self.manual
      "/admin/manuals/#{target_manual.id}"
    elsif !self.review_id.nil?
      target_review = self.review
      "/admin/reviews/#{target_review.id}"
    else
      nil
    end

  end


end
