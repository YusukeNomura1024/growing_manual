class Admin::MessagesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @messages = Message.where(user_id: @user.id).page(params[:page]).per(8).reverse_order
    @message = Message.new
  end

  def create
    @user = User.find(params[:user_id])
    @messages = Message.where(user_id: @user.id).page(params[:page])
    @message = Message.new(message_params)
    @message.is_replied = true
    if @message.save
      flash[:notice] = "送信しました"
      @user.create_notification_from_admin!
      redirect_to admin_user_messages_path(@user)
    else
      flash[:alert] = "送信できませんでした#{@message.errors.full_messages}"
      redirect_to admin_user_messages_path(@user)
    end
  end

  def update
    @user = User.find(params[:user_id])
    @messages = Message.where(user_id: @user.id).page(params[:page])
    @message = Message.new
    message = Message.find(params[:id])
    message.update(is_replied: true)
    redirect_to admin_user_messages_path(@user)
  end


  def destroy
    @user = User.find(params[:user_id])
    @messages = Message.where(user_id: @user.id).page(params[:page])
    @message = Message.new
    message = Message.find(params[:id])
    message.destroy
    redirect_to admin_user_messages_path(@user)
  end

  private

  def message_params
    params.require(:message).permit(:type, :comment).merge(user_id: params[:user_id])
  end

end
