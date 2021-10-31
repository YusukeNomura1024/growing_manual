class Public::BookmarksController < ApplicationController
before_action :authenticate_user!

  def create
    @manual = Manual.find(params[:manual_id])
    bookmark = @manual.bookmarks.new(user_id: current_user.id)
    if bookmark.save
      @manual.create_notification_bookmark!(current_user)
      flash[:bookmark] = "ブックマークしました"
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
      flash[:bookmark] = "ブックマークを解除しました"
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end
end
