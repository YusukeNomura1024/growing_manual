class Public::MessagesController < ApplicationController
  def index
  end

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
    case params[:message][:report_target]
    when 'manual'
      manual = Manual.find(params[:message][:manual_id])
      redirect_to manual_path(manual)
    when 'review'
      redirect_to request.referer
    end
  end

  private

  def message_params
    params.require(:message).permit(:type, :comment, :manual_id, :review_id).merge(user_id: current_user.id)
  end
end
