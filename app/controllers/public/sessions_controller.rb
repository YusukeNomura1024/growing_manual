class Public::SessionsController < Devise::SessionsController
  before_action :reject_inactive_user, only: [:create]

  def reject_inactive_user
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.active_for_authentication? == false)
        flash[:alert] = "退会済みです"
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = "必須項目を入力してください"
    end
  end
end
