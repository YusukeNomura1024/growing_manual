class Public::MemoLinksController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about, :show]
  before_action :non_owner_to_root, only: [:destroy, :update, :edit]

  def index
    @memo = Memo.find(params[:memo_id])
    @memo_links = @memo.memo_links.page(params[:page]).reverse_order
  end

  def show
    @memo_link = MemoLink.find(params[:id])
    respond_to do |format|
      format.html

      format.js { render 'show' }
    end
  end

  def new
    begin
      if params[:sort] == 'created_at' || params[:sort].nil?
        @memos = where_user_id_is_current_user_id(Memo).page(params[:page]).reverse_order
        params[:sort] = 'created_at'
      elsif params[:sort] == 'updated_at'
        @memos = where_user_id_is_current_user_id(Memo).order(updated_at: "DESC").page(params[:page])
      end
    rescue
      params[:sort] = 'created_at'
      flash[:notice] = "無効な操作がされましたので、ソートをデフォルトに戻しました"
    end

    @categories = Category.where(user_id: current_user.id)
    @procedure = Procedure.find(params[:id])
    @manual = Manual.find(@procedure.manual_id)
    @memo_link = MemoLink.new
    # 別のuserがprocedureにリンクを設定できないように制限
    if @manual.user != current_user
      redirect_to manual_path(@manual)
    end

  end

  def search
    @categories = where_user_id_is_current_user_id(Category)
    if params[:category_id].nil?
      params[:category_id] = ""
    end
    @total_memos = where_user_id_is_current_user_id(Memo).search(params[:keyword], params[:category_id])
    @memos = @total_memos.page(params[:page]).reverse_order
    @procedure = Procedure.find(params[:id])
    @manual = Manual.find(@procedure.manual_id)
    @memo_link = MemoLink.new
    if @memos.count == 0
      @list_title = "キーワード「#{params[:keyword]}」 の該当なし"
    else
      @list_title = "キーワード「#{params[:keyword]} 」の検索結果一覧 （全 #{@total_memos.count}件）"
    end
    render :new
  end

  def create
    @memo_link = MemoLink.new(memo_link_params)

    # 登録済みの場合は登録済みとアナウンスして、登録しないようにする
    if @memo_link.is_unique?
      @memo_link.save
      flash.now[:notice] = "#{@memo_link.memo.name}を登録しました"
    else
      flash.now[:alert] = "既に登録済みです"

    end
  end

  def destroy
    @manual = Manual.find(params[:manual_id])
    @memo_link.destroy
    redirect_to manual_path(@manual)
  end

  private

  def non_owner_to_root
    @memo_link = MemoLink.find(params[:id])
    if @memo_link.memo.user != current_user
      redirect_to root_path
    end
  end


  def memo_link_params
    params.require(:memo_link).permit(:memo_id, :procedure_id)
  end

end
