class Public::MemoLinksController < ApplicationController
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

  private

  def memo_link_params
    params.require(:memo_link).permit(:memo_id, :procedure_id)
  end

end
