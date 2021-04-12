# frozen_string_literal: true

class DashboardsController < ApplicationController
  skip_before_action :admin_authorized, only: %i[user]

  def user
    @user = current_user
    curr_meeting = Meeting.current_meeting
    @show_signin = !curr_meeting.nil? && curr_meeting.user_exists?(@user) && !curr_meeting.attended_meeting?(@user)
  end

  def admin
    @meetings = Meeting.all
  end
end
