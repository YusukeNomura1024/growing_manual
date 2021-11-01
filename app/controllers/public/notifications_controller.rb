class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  before_action :non_owner_to_root, only: [:index]

  def index
    @notifications = current_user.passive_notifications.page(params[:page]).reverse_order
    @notifications.where(is_checked: false).each do |notification|
      notification.update_attributes(is_checked: true)
    end
  end

  def non_owner_to_root
    unless current_user.id == params[:user_id].to_i || admin_user_signed_in?
      redirect_to '/'
    end
  end

end
