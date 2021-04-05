# frozen_string_literal: true

# when a user logs in, stores their user_id
class SessionsController < ApplicationController
  skip_before_action :user_authorized, only: %i[new create]
  skip_before_action :admin_authorized, only: %i[new create destroy]

  def new; end

  def create
    @user = User.find_by(username: params[:username])
    post_login_url = '/login'
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      post_login_url = @user.admin? ? admin_dashboards_path : user_dashboards_path
    end
    redirect_to post_login_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end
