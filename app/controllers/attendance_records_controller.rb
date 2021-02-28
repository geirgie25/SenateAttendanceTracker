class AttendanceRecordsController < ApplicationController

    # we need to add verifications if a user loggedin/admin when will is done

    def index
        # these are temporary variables until we can actually get user information
        logged_in = true
        is_admin = true


        if logged_in && is_admin # if admin
            @meetings = Meeting.all

            render :administrator
        elsif logged_in # if not admin but logged
            # FIXME: change to current user once login is figured out
            @user = User.first
            @total_absences = AttendanceRecord.find_total_absences(@user)
            @excused_absences = AttendanceRecord.find_total_excused_absences(@user)
            @unexcused_absences = @total_absences - @excused_absences
            render :user
        else
            # redirect to login page
        end

    end

    def view_meeting
        # another temp variables

        logged_in = true
        is_admin = true

        if logged_in && is_admin
            #showing the attendance record on page
            @meeting_id = params[:meeting_id]
            @meeting = Meeting.find(@meeting_id)
            @records = @meeting.attendance_records

            render :view_meeting
        elsif logged_in
            render :user
        else
            # redirect to login
        end

    end

    def sign_into_meeting
        curr_meeting = Meeting.get_current_meeting
        unless curr_meeting.nil?

        end
    end

end
