class AccountsController < ApplicationController

  skip_before_action :authorized, only: [:new, :create]


  def new
    @account = Account.new
  end

  def create
    @account = Account.create(params.require(:user).permit(:username, :password))
    session[:account_id] = @account.id
    redirect_to '/welcome'
  end
end
