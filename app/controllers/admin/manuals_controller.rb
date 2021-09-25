class Admin::ManualsController < ApplicationController
  def index
    @tags = Tag.all
    @manuals = Manual.page(params[:page]).reverse_order
    # トップページを表示する場合は必ずparamsに:sortを追加する
    if params[:sort] == 'created_at' || params[:sort].nil?
      @manuals = Manual.page(params[:page]).reverse_order
      params[:sort] = 'created_at'
    elsif params[:sort] == 'bookmarks'
      @manuals = Manual.includes(:bookmarked_users).sort {|a,b| b.bookmarked_users.size <=> a.bookmarked_users.size}
      @manuals = Kaminari.paginate_array(@manuals).page(params[:page])
    end

  end

  def show
    @manual = Manual.find(params[:id])
    @procedures = @manual.procedures
    @user = current_user
    @message = Message.new
  end

  def edit
    @manual = Manual.find(params[:id])
  end

  def update
    manual = Manual.find(params[:id])
    manual.update(manual_params)
    redirect_to admin_manual_path(manual)
  end

  def destroy
    manual = Manual.find(params[:id])
    manual.destroy
    redirect_to admin_manuals_path
  end

  def search
    @tags = Tag.all
    @manuals = Manual.search(params[:keyword]).page(params[:page]).reverse_order
    list_title_set

    render 'admin/manuals/index'
  end

  private

  def manual_params
    params.require(:manual).permit(:title, :image_id, :description, :status, :release_date)
  end

  def list_title_set
    if @manuals.count == 0
      @list_title = "「#{params[:keyword]}」 の該当なし"
    else
      @list_title = "#{params[:keyword]} の検索結果一覧 （全 #{@manuals.count}件）"
    end
  end
end
