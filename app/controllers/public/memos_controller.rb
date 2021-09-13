class Public::MemosController < ApplicationController
  def index
    @memos = Memo.where(user_id: current_user.id)
  end

  def show
  end

  def new
    @memo = Memo.new
    @categories = Category.where(user_id: current_user.id)
    @category = Category.new
  end

  def create
    @memo = Memo.new(memo_params)
    @memo.save
    redirect_to memos_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

private

  def memo_params
    params.require(:memo).permit(:category_id, :name, :description, :url, :code).merge(user_id: current_user.id)
  end

end
