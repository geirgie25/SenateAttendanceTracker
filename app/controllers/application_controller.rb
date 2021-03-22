# frozen_string_literal: true

# controller which all other controllers derive from
class ApplicationController < ActionController::Base
  before_action :user_authorized
  before_action :admin_authorized
  helper_method :current_user
  helper_method :log_check

  # current_user FUNCTION
  #   determines the user that is currently logged in
  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  # log_check FUNCTION
  #   use to check if currently (used also in authorization)
  def logged_in?
    !current_user.nil?
  end

  # user_authorized FUNCTION
  #   used to redirect to welcome unless logged in
  def user_authorized
    redirect_to '/login' unless logged_in?
  end

  # admin_authorized FUNCTION
  #   used to redirect to welcome unless an admin
  def admin_authorized
    if logged_in? && !current_user.admin?
      redirect_to '/dashboard/user'
    elsif !logged_in?
      redirect_to '/login'
    end
  end

  helper_method :logged_in?, :current_user
end
