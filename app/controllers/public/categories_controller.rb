class Public::CategoriesController < ApplicationController
  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
    @category.save
    @categories = Category.where(user_id: current_user.id)

  end

  def destroy
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
