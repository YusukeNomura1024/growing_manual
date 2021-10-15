class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  before_action :manual_get
  before_action :non_owner_to_root, only: [:update, :edit, :review]


  def index
    @manual = Manual.find(params[:manual_id])
    @reviews = Review.where(manual_id: @manual.id).where.not(user_id: current_user.id).page(params[:page]).per(20)
    @review = Review.find_by(user_id: current_user.id, manual_id: @manual.id)
    @user = current_user
    @message = Message.new
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

    #通知の作成
    @manual.create_notification_review!(current_user, review.id, @manual.user_id)

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
    @manual = Manual.find(params[:manual_id])
    @review = Review.find(params[:id])
    if Review.find_by(user_id: current_user.id, manual_id: @manual.id).nil?
      @review = Review.new
      @review.rate = 0
      @button_name = '評価する'
    else
      @review = Review.find_by(user_id: current_user.id, manual_id: @manual.id)
      @button_name = '反映する'
    end

  end


  private

  def non_owner_to_root
    @review = Review.find(params[:id])
    unless @review.user == current_user
      redirect_to '/'
    end
  end

  def review_params
    params.require(:review).permit(:rate, :comment).merge(manual_id: params[:manual_id], user_id: current_user.id)
  end

  def manual_get
    @manual = Manual.find(params[:manual_id])
  end


end
