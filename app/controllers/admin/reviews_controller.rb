class Admin::ReviewsController < ApplicationController
  def index
    @manual = Manual.find(params[:manual_id])
    @reviews = Review.where(manual_id: @manual.id).page(params[:page])
  end

  def destroy
    manual = Manual.find(params[:manual_id])
    review = Review.find(params[:id])
    review.destroy
    redirect_to admin_manual_reviews_path(manual)
  end
end
