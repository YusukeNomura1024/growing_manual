class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  
  def index
    @notifications = current_user.passive_notifications.page(params[:page])
    @notifications.where(is_checked: false).each do |notification|
      notification.update_attributes(is_checked: true)
    end
  end

end
