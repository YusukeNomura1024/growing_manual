class Public::MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :non_owner_to_root, only: [:show, :destroy, :update, :edit]

  def index
    @categories = where_user_id_is_current_user_id(Category)
    if params[:sort] == 'created_at' || params[:sort].nil?
      @memos = where_user_id_is_current_user_id(Memo).page(params[:page]).reverse_order
      params[:sort] = 'created_at'
    elsif params[:sort] == 'updated_at'
      @memos = where_user_id_is_current_user_id(Memo).order(updated_at: "DESC").page(params[:page]).per(9)
    end
  end

  def search
    @categories = where_user_id_is_current_user_id(Category)
    if params[:category_id].nil?
      params[:category_id] = ""
    end
    @memos = where_user_id_is_current_user_id(Memo).search(params[:keyword], params[:category_id]).page(params[:page]).per(9).reverse_order
    if @memos.count == 0
      @list_title = "キーワード「#{params[:keyword]}」 の該当なし"
    else
      @list_title = "キーワード「#{params[:keyword]} 」の検索結果一覧 （全 #{@memos.count}件）"
    end
    render :index
  end

  def show
    @memo = Memo.find(params[:id])
  end

  def link

    @memo = Memo.find(params[:id])
    @memo_link = MemoLink.new

  end

  def new
    @memo = Memo.new
    @categories = where_user_id_is_current_user_id(Category)
    @category = Category.new
  end

  def create
    @memo = Memo.new(memo_params)
    @categories = where_user_id_is_current_user_id(Category)
    @category = Category.new

    # procedureにも登録するかどうか判断
    if !params[:memo][:procedure_id].nil?
      if @memo.save
        flash[:notice] = "登録しました"
      else
        flash[:alert] = "登録できませんでした#{@memo.errors.full_messages}"
      end

      manual = Procedure.find(params[:memo][:procedure_id]).manual
      # manualの製作者かどうか判断
      if manual.user == current_user
        memo_link = MemoLink.new
        memo_link.procedure_id = params[:memo][:procedure_id]
        memo_link.memo_id = @memo.id
        memo_link.save
        redirect_to manual_path(manual)
      else
        flash[:error] = "他人のマニュアルにメモを登録はできません"
        redirect_to memo_path(@memo)
      end
    else

      if @memo.save
        flash[:notice] = "登録しました"
        redirect_to memo_path(@memo)
      else
        flash.now[:alert] = "登録できませんでした"
        @page = "new"
        render :new
      end
    end

  end

  def edit
    @memo = Memo.find(params[:id])
    @categories = where_user_id_is_current_user_id(Category)
    @category = Category.new
  end

  def update
    @memo = Memo.find(params[:id])
    @categories = where_user_id_is_current_user_id(Category)
    @category = Category.new
    # マニュアルからの遷移の場合はマニュアルページに戻る
    if !params[:memo][:manual_id].nil?
      if @memo.update(memo_params)
        flash[:notice] = "更新しました"
      else
        flash[:alert] = "更新できませんでした（入力漏れ・文字数オーバー）"
      end
      manual = Manual.find(params[:memo][:manual_id])
      redirect_to manual_path(manual)
    else
      if @memo.update(memo_params)
        flash[:notice] = "更新しました"
        redirect_to memo_path(@memo)
      else
        flash.now[:alert] = "更新できませんでした"
        @page = "edit"
        render :edit
      end
    end
  end

  def destroy
    memo = Memo.find(params[:id])
    memo.destroy
    flash[:notice] = "削除しました"
    redirect_to memos_path
  end

  private

  def non_owner_to_root
    @memo = Memo.find(params[:id])
    unless current_user.id == @memo.user_id || admin_user_signed_in?
      redirect_to '/'
    end
  end


  def memo_params
    params.require(:memo).permit(:category_id, :name, :description, :url, :code).merge(user_id: current_user.id)
  end

end
