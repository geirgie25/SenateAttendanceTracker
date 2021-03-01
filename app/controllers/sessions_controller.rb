class SessionsController < ApplicationController

  skip_before_action :user_authorized, only: [:new, :create]
  skip_before_action :admin_authorized, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      if @user.is_admin
        redirect_to '/dashboard/admin' and return
      else
        redirect_to '/dashboard/user' and return
      end
    end
    redirect_to '/login'
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
  
end
