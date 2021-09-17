class Public::MessagesController < ApplicationController
  def index
  end

  def new
    @user = current_user
    @message = Message.new
    @manual = Manual.find(params[:manual_id])
  end

  def create
    message = Message.new(message_params)
    manual = Manual.find(params[:message][:manual_id])
    message.save
    redirect_to manual_path(manual)
  end

  private

  def message_params
    params.require(:message).permit(:type, :comment, :manual_id).merge(user_id: current_user.id)
  end
end
