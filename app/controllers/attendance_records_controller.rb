# frozen_string_literal: true

# controls attendance records. temp
class AttendanceRecordsController < ApplicationController
  skip_before_action :admin_authorized, only: %i[user_dashboard sign_in]

  def user_dashboard
    @user = current_user
    @total_absences = AttendanceRecord.find_total_absences(@user)
    @excused_absences = AttendanceRecord.find_total_excused_absences(@user)
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

  def start_signin
    @committee = Committee.get_committee_by_name('General')
    @meeting = Meeting.create(committee: @committee, start_time: Time.now)
    if @meeting.save
      AttendanceRecord.make_records_for(@meeting)
      notice = 'Meeting Sign-in Started.'
    else
      notice = "Couldn't save meeting sign-in."
    end
    redirect_to(action: :admin_dashboard, notice: notice)
  end

  def end_signin
    curr_meeting = Meeting.current_meeting
    redirect_notice = 'There is no meeting sign-in occuring.'
    unless curr_meeting.nil?
      curr_meeting.end_meeting
      redirect_notice = curr_meeting.save ? 'Meeting Sign-in Ended.' : "Couldn't save meeting sign-in ended."
    end
    redirect_to(action: :admin_dashboard, notice: redirect_notice)
  end

  def sign_in
    user = current_user
    curr_meeting = Meeting.current_meeting
    redirect_notice = 'Meeting sign in period has already ended.'
    unless curr_meeting.nil?
      record = AttendanceRecord.find_record(curr_meeting, user)
      if record.nil?
        redirect_notice = 'User is not signed up for this meeting.'
      else
        record.attended = true
        redirect_notice = record.save ? 'Signed into Meeting.' : "Attendance record couldn't be saved."
      end
    end
    redirect_to(action: :user_dashboard, notice: redirect_notice)
  end
end
