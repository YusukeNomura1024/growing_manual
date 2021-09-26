class Public::MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :non_owner_to_root, only: [:show, :destroy, :update, :edit]

  def index
    @categories = Category.where(user_id: current_user.id)
    @memos = where_user_id_is_current_user_id(Memo).page(params[:page]).reverse_order

  end

  def search
    @categories = where_user_id_is_current_user_id(Category)
    @memos = where_user_id_is_current_user_id(Memo).page(params[:page]).reverse_order
    if @memos.count == 0
      @list_title = "「#{params[:keyword]}」 の該当なし"
    else
      @list_title = "#{params[:keyword]} の検索結果一覧 （全 #{@memos.count}件）"
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
    if params[:preview_button]
      @categories = Category.where(user_id: current_user.id)
      @category = Category.new
      render :new
    else
      @memo.save

      # procedureにも登録するかどうか判断
      if !params[:memo][:procedure_id].nil?
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
    if !params[:preview_button].nil?
      @memo = Memo.new(memo_params)
      @categories = where_user_id_is_current_user_id(Category)
      @category = Category.new
      render :edit
    else

      @memo.update(memo_params)
      redirect_to memo_path(@memo)
    end

  end

  def destroy
    memo = Memo.find(params[:id])
    memo.destroy
    redirect_to memos_path
  end

  def non_owner_to_root
    @memo = Memo.find(params[:id])
    unless current_user.id == @memo.user_id || admin_user_signed_in?
      redirect_to '/'
    end
  end


private

  def memo_params
    params.require(:memo).permit(:category_id, :name, :description, :url, :code).merge(user_id: current_user.id)
  end

end
