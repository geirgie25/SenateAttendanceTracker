# frozen_string_literal: true

class DashboardsController < ApplicationController
  skip_before_action :user_authorized, only: %i[help]
  skip_before_action :admin_authorized, only: %i[user help]

  def user
    @user = current_user
    curr_meeting = Meeting.current_meeting
    @show_signin = !curr_meeting.nil? && curr_meeting.user_exists?(@user) && !curr_meeting.attended_meeting?(@user)
  end

  def admin
    @meetings = Meeting.all
  end

  def help; end
end
