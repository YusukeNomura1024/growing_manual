class Public::BookmarksController < ApplicationController
before_action :authenticate_user!

  def create
    @manual = Manual.find(params[:manual_id])
    bookmark = @manual.bookmarks.new(user_id: current_user.id)
    if bookmark.save
      @manual.create_notification_bookmark!(current_user)
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end

  def destroy
    @manual = Manual.find(params[:manual_id])
    bookmark = @manual.bookmarks.find_by(user_id: current_user.id)
    if bookmark.present?
      bookmark.destroy
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end
end
