class SessionsController < ApplicationController

  skip_before_action :authorized, only: [:new, :create, :welcome]

  def new

  end

  def create
    @account = Account.find_by(username: params[:username])
    if @account && @account.authenticate(params[:password])
      sessions[:account_id] = @account.id
      redirect_to '/welcome'
    else
      redirect_to '/login'
  end

  def login
  end

  def welcome
  end

  def page_requires_login
  end
  
end
