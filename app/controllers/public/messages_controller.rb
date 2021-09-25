class Public::MessagesController < ApplicationController
  before_action :authenticate_user!, except: [:top, :about]
  
  def index
    @messages = Message.where(user_id: current_user.id).page(params[:page]).per(20).reverse_order
    @message = Message.new
  end

# マニュアルとレビューの違反報告時のみのアクション
  def new
    @user = current_user
    @message = Message.new
    case params[:report_target]
    when 'manual'
      @manual = Manual.find(params[:manual_id])
      render 'new'
    when 'review'
      @review = Review.find(params[:review_id])
      render 'new_target_review'
    end
  end

  def create
    message = Message.new(message_params)
    message.save
    # 違反報告時とお問い合わせの処理
    case params[:message][:report_target]
    when 'manual'
      manual = Manual.find(params[:message][:manual_id])
      redirect_to manual_path(manual)
    when 'review'
      redirect_to request.referer
    when 'no_target'
      flash[notice] = "送信しました"
      redirect_to user_messages_path(current_user)
    end
  end

  private

  def message_params
    params.require(:message).permit(:type, :comment, :manual_id, :review_id).merge(user_id: current_user.id)
  end
end
