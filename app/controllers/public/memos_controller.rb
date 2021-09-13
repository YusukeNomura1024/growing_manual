class Public::MemosController < ApplicationController
  def index
  end

  def show
  end

  def new
    @memo = Memo.new
    @categories = Category.where(user_id: current_user.id)
    @category = Category.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
