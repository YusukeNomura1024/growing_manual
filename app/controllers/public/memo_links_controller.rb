class Public::MemoLinksController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
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
    @memos = Memo.where(user_id: current_user.id).page(params[:page]).reverse_order
    @categories = Category.where(user_id: current_user.id)
    @procedure = Procedure.find(params[:id])
    @manual = Manual.find(@procedure.manual_id)
    @memo_link = MemoLink.new
    # 別のuserがprocedureにリンクを設定できないように制限
    if @manual.user != current_user
      redirect_to manual_path(@manual)
    end
  end


  def create
    @memo_link = MemoLink.new(memo_link_params)
    @memo_link.save
    flash[notice] = "#{@memo_link.memo.name}を登録しました"
  end

  def destroy
    @manual = Manual.find(params[:manual_id])
    @memo_link.destroy
    redirect_to manual_path(@manual)
  end

  def non_owner_to_root
    @memo_link = MemoLink.find(params[:id])
    if @memo_link.memo.user != current_user
      redirect_to root_path
    end
  end

  private

  def memo_link_params
    params.require(:memo_link).permit(:memo_id, :procedure_id)
  end

end
