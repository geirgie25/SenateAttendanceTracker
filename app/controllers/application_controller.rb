class ApplicationController < ActionController::Base

  before_action :authorized
  helper_method :current_account
  helper_method :log_check

  # current_account FUNCTION
  #   determines the user that is currently logged in
  def current_account
    Account.find_by(id: session[:account_id])
  end

  # log_check FUNCTION
  #   use to check if currently (used also in authorization)
  def log_check
    !current_account.nil?
  end

  # authorized FUNCTION
  #   use to check if user is allowed to access site
  #   (currently only implemented to check if logged in, not admin or antyhing else)
  def authorized
    redirect_to '/welcome' unless log_check
  end

end
