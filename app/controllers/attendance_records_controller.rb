# frozen_string_literal: true

# controls attendance records. temp
class AttendanceRecordsController < ApplicationController
  skip_before_action :admin_authorized, only: %i[user_dashboard index]

  def index
    @records = AttendanceRecord.records(current_user)
  end

  def user_dashboard
    @user = current_user
    @total_absences = AttendanceRecord.find_total_absences(@user.committee_enrollments)
    @excused_absences = AttendanceRecord.find_total_excused_absences(@user.committee_enrollments)
    @unexcused_absences = @total_absences - @excused_absences

    curr_meeting = Meeting.current_meeting
    @show_signin = !curr_meeting.nil? && curr_meeting.user_exists?(@user) && !curr_meeting.attended_meeting?(@user)

    render :user
  end

  def admin_dashboard
    @show_start_meeting = Meeting.current_meeting.nil?
    @meetings = Meeting.all
    render :administrator
  end

  def view_meeting
    @meeting_id = params[:meeting_id]
    @meeting = Meeting.find(@meeting_id)
    @records = @meeting.attendance_records
    render :view_meeting
  end
end
