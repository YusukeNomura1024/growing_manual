class Admin::ManualsController < ApplicationController
  def index
    @tags = Tag.all
    @manuals = Manual.page(params[:page]).reverse_order
    # トップページを表示する場合は必ずparamsに:sortを追加する
    if params[:sort] == 'created_at' || params[:sort].nil?
      @manuals = Manual.preload(:bookmarks, :reviews, :user).page(params[:page]).reverse_order
      params[:sort] = 'created_at'
    elsif params[:sort] == 'bookmarks'
      @manuals = Manual.preload(:bookmarks, :reviews, :user, :bookmarked_users).sort {|a,b| b.bookmarked_users.size <=> a.bookmarked_users.size}
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
    @manual = Manual.find(params[:id])
    if @manual.update(manual_params)
      flash[:notice] = "更新しました"
      redirect_to admin_manual_path(@manual)
    else
      flash.now[:alert] = "更新できませんでした"
      render :edit
    end
  end

  def destroy
    manual = Manual.find(params[:id])
    deleted_manual_title = manual.title
    manual_creator = manual.user
    if manual.destroy
      flash[:notice] = "削除しました。会員に削除通知を送りました。"
      manual_creator.create_message_deleted_user_manual!(deleted_manual_title)
      redirect_to admin_manuals_path
    else
      flash.now[:alert] = "削除できませんでした"
      render :edit
    end
  end

  def search
    @tags = Tag.all
    @manuals = Manual.preload(:bookmarks, :reviews, :user, :bookmarked_users).search(params[:keyword]).page(params[:page]).reverse_order
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
