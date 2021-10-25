class ApplicationController < ActionController::Base

  include ListFilter

  def after_sign_in_path_for(resource)
    case resource
    when AdminUser
      admin_root_path
    when User
      '/'
    end
  end

  def after_sign_out_path_for(resource)
    case resource
    when :admin_user
      new_admin_user_session_path
    when :user
      new_user_session_path
    end
  end

  def after_inactive_sign_up_path_for(resource)
    case resource
    when :admin_user
      admin_users_home_path
    when :user
      '/'
    end
  end

  def flash_notice__edit_success
    flash[:notice] = "更新しました"
  end

  def flash_alert__error
    flash.now[:alert] = "保存・更新できませんでした"
  end



end
