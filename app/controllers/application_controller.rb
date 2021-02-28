class ApplicationController < ActionController::Base


  before_action :user_authorized
  before_action :admin_authorized
  helper_method :current_user
  helper_method :log_check

  # current_user FUNCTION
  #   determines the user that is currently logged in
  def current_user
    if session[:user_id].nil?
      return nil
    end
    return User.find(session[:user_id])
  end

  # log_check FUNCTION
  #   use to check if currently (used also in authorization)
  def log_check
    return !current_user.nil?
  end


  # user_authorized FUNCTION
  #   used to redirect to welcome unless logged in
  def user_authorized
    redirect_to '/login' unless log_check
  end

  # admin_authorized FUNCTION
  #   used to redirect to welcome unless an admin
  def admin_authorized
    if log_check && !current_user.is_admin
      redirect_to '/dashboard/user'      
    elsif !log_check
      redirect_to '/login'
    end
  end

end
