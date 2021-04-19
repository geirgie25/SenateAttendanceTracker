# frozen_string_literal: true
require 'csv'
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

  def download_session
    file = File.new("public/attendance_data.csv", "w")
    file.close
    CSV.open("public/attendance_data.csv", "w") do |csv|
      csv << ["Committee Attendance Summaries"]
      csv << []
      Committee.all.each do |committee|
        csv << [committee.committee_name + " Committee"]
        csv << ["Name", "Attendances", "Excused Absences", "Unexcused Absences"]
        committee.committee_enrollments.each do |enrollment|
          csv << [ 
            enrollment.user.name,
            AttendanceRecord.find_total_attendances(enrollment),
            AttendanceRecord.find_total_excused_absences(enrollment),
            AttendanceRecord.find_total_unexcused_absences(enrollment)
          ]
        end
        csv << []
      end
      csv << []
      csv << ["Meeting Records"]
      csv << []
      Committee.all.each do |committee|
        csv << [committee.committee_name + " Committee"]
        committee.meetings.each do |meeting|
          csv << [meeting.title, meeting.start_time, meeting.end_time]
          csv << ["Name", "Attendance Status"]
          meeting.attendance_records.each do |record|
            csv << [
              record.committee_enrollment.user.name,
              attendance_status_string(record)
            ]
          end
          csv << []
        end
        csv << []
      end
    end

    send_file("public/attendance_data.csv")
  end

  def delete_records
    Meeting.destroy_all
    redirect_to admin_dashboards_path
  end

  def help; end

  private
  
  def attendance_status_string(record)
    return 'Attended' if record.attended
    return 'Excused Absence' if record.excuse && record.excuse.status == 'Approved'

    'Unexcused Absence'
  end
end
