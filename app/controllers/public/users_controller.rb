class Public::UsersController < ApplicationController
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
    user = current_user
    user.update(user_params)
    redirect_to user_path(user.id)

  end

  def unsubscribe
  end

  def withdraw
    user = current_user
    user.update(is_active: false)

    reset_session
    flash[:notice] = "ありがとうございました"
    redirect_to '/'

  end

  def oneself?
    params[:id] == current_user.id
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :pen_name, :email)
  end

end
