class ApplicationController < ActionController::Base

  before_action :authorized
  helper_method :current_account
  helper_method :log_check

  def current_account
    Account.find_by(id: session[:account_id])
  end

  def log_check
    !current_account.nil?
  end

  def authorized
    redirect_to '/welcome' unless log_check
  end

end
