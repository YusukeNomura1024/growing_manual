class Public::UsersController < ApplicationController

  before_action :authenticate_user!, except: [:top, :about]

  def show
    @user = User.find(params[:id])

    if @user.id == current_user.id
      @oneself = true
    else
      @oneself = false
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "更新しました"
      redirect_to user_path(@user.id)
    else
      flash.now[:alert] = "更新できませんでした"
      render :edit
    end
  end
  
  def password_edit
    @user = User.find(current_user)
  end
  
  def password_reset
    @user = current_user
    if @user.updata(user_params)
      flash[:notice] = "更新しました"
      redirect_to user_path(@user.id)
    else
      flash.now[:alert] = "更新できませんでした"
      render :password_edit
    end
  end

  def unsubscribe
  end

  def withdraw
    user = current_user
    user.update(is_active: false)

    reset_session
    flash[:notice] = "ありがとうございました退会手続きが完了いたしました"
    redirect_to '/'

  end

  private

  def oneself?
    params[:id] == current_user.id
  end



  def user_params
    params.require(:user).permit(:full_name, :pen_name, :email, :image, :reset_password_token, :password, :password_confirmation)
  end

end
