class Admin::MessagesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @messages = Message.where(user_id: @user.id)
    @message = Message.new
  end

  def create
    @user = User.find(params[:user_id])
    @messages = Message.where(user_id: @user.id).page(params[:page])
    @message = Message.new(message_params)
    @message.is_replied = true
    if @message.save
      flash[:notice] = "送信しました"
      redirect_to admin_user_messages_path(@user)
    else
      flash.now[:error] = "送信できませんでした"
      render 'create'
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
