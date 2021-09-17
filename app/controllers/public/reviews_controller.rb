class Public::ReviewsController < ApplicationController
  before_action :manual_get

  def index
    @reviews = Review.where.not(user_id: current_user.id).page(params[:page]).per(3)
    @review = Review.find_by(user_id: current_user.id)
    if @review.nil?
      @review = Review.new
      @review.rate = 0
    end

  end

  def new
    @review = Review.new
    @review.rate = 0
    @button_name = '評価する'
    render :edit

  end

  def create
    review = Review.new(review_params)
    review.save
    @manual = Manual.find(params[:manual_id])
    redirect_to manual_reviews_path(@manual)
  end

  def update
    review = Review.find(params[:id])
    review.update(review_params)
    redirect_to manual_reviews_path(@manual)
  end

  def destroy
    review = Review.find(params[:id])
    review.destroy
    redirect_to manual_reviews_path(@manual)
  end

  def edit
    @review = Review.find(params[:id])
    if Review.find_by(user_id: current_user.id).nil?
      @review = Review.new
      @review.rate = 0
      @button_name = '評価する'
    else
      @review = Review.find_by(user_id: current_user.id)
      @button_name = '反映する'
    end

  end


  private

  def review_params
    params.require(:review).permit(:rate, :comment).merge(manual_id: params[:manual_id], user_id: current_user.id)
  end

  def manual_get
    @manual = Manual.find(params[:manual_id])
  end


end
