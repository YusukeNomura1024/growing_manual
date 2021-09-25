class Public::MemoLinksController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  before_action :non_owner_to_root, only: [:destroy, :update, :edit]
  
  def index
  end

  def new
    @memos = Memo.where(user_id: current_user.id).page(params[:page]).reverse_order
    @categories = Category.where(user_id: current_user.id)
    @procedure = Procedure.find(params[:id])
    @manual = Manual.find(@procedure.manual_id)
    @memo_link = MemoLink.new
  end


  def create
    @memo_link = MemoLink.new(memo_link_params)
    @memo_link.save
    flash[notice] = "#{@memo_link.memo.name}を登録しました"

  end

  def destroy
  end

  def non_owner_to_root
    @memo_link = MemoLink.find(params[:id])
    redirect_to root_path
  end

  private

  def memo_link_params
    params.require(:memo_link).permit(:memo_id, :procedure_id)
  end

end
