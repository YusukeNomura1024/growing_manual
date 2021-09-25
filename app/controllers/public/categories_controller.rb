class Public::CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  
  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
    @category.save
    @categories = Category.where(user_id: current_user.id)

  end

  def index
    @categories = Category.where(user_id: current_user.id)
  end

  def show
    @category = Category.find(params[:id])
    @categories = Category.where(user_id: current_user.id)
    @memos = @category.memos.page(params[:page])
    if @memos.count == 0
      @list_title = "「#{@category.name}」 の該当なし"
    else
      @list_title = "#{@category.name} の検索結果一覧 （全 #{@memos.count}件）"
    end
    render 'public/memos/index'
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    redirect_to categories_path
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
