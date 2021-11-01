class Public::CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]

  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
    @categories = Category.preload(:memos).where(user_id: current_user.id)

    if @category.save
      flash[:notice] = "登録しました"
      redirect_to categories_path
    else
      flash.now[:alert] = "登録できませんでした"
      render :index
    end

  end

  def index
    @category = Category.new
    @categories = Category.preload(:memos).where(user_id: current_user.id)
  end

  def show
    @category = Category.find(params[:id])
    @categories = where_user_id_is_current_user_id(Category.preload(:memos))
    @memos = @category.memos.page(params[:page]).reverse_order

    if @memos.count == 0
      @list_title = "「#{@category.name}」 の該当なし"
    else
      @list_title = "#{@category.name} の検索結果一覧 （全 #{@category.memos.count}件）"
    end
    render 'public/memos/index'
  end

  def destroy
    category = Category.find(params[:id])
    if category.user_id == current_user.id
      category.destroy
      flash[:notice] = "削除しました"
      redirect_to categories_path
    else
      redirect_to categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
