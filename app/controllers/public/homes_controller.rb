class Public::HomesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  def top
    @tags = Tag.all
    # トップページを表示する場合は必ずparamsに:sortを追加する
    if params[:sort] == 'created_at' || params[:sort].nil?
      @manuals = Manual.where(status: true).page(params[:page]).reverse_order
      params[:sort] = 'created_at'
    elsif params[:sort] == 'bookmarks'
      @manuals = Manual.includes(:bookmarked_users).where(status: true).sort {|a,b| b.bookmarked_users.size <=> a.bookmarked_users.size}
      @manuals = Kaminari.paginate_array(@manuals).page(params[:page])
    end

  end



  def about
  end
end
