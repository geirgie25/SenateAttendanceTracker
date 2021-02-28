class AttendanceRecordsController < ApplicationController

    skip_before_action :admin_authorized, only: [:user_dashboard, :sign_into_meeting]
    
    def user_dashboard
        @user = current_user
        @total_absences = AttendanceRecord.find_total_absences(@user)
        @excused_absences = AttendanceRecord.find_total_excused_absences(@user)
        @unexcused_absences = @total_absences - @excused_absences
        
        curr_meeting = Meeting.get_current_meeting
        @show_signin = !curr_meeting.nil? && curr_meeting.signed_up_for_meeting(@user) && !curr_meeting.attended_meeting(@user) 

        render :user
    end

    def admin_dashboard
        @show_start_meeting = Meeting.get_current_meeting.nil?
        @meetings = Meeting.all
        render :administrator
    end

    def view_meeting
        @meeting_id = params[:meeting_id]
        @meeting = Meeting.find(@meeting_id)
        @records = @meeting.attendance_records
        render :view_meeting
    end

    def start_meeting_signin
        @committee = Committee.get_committee_by_name("General")

        if !@committee.nil?
            @meeting = Meeting.create(committee: @committee)
            @meeting.start_meeting
            if @meeting.save
                AttendanceRecord.make_records_for(@meeting)
                redirect_to(action: :admin_dashboard, notice: "Meeting Sign-in Started.") and return
            end
            
            redirect_to(action: :admin_dashboard, notice: "Couldn't save meeting sign-in.") and return
        end
        redirect_to(action: :admin_dashboard, notice: "Couldn't find committee General.") and return
    end

    def end_meeting_signin
        curr_meeting = Meeting.get_current_meeting
        unless curr_meeting.nil?
            curr_meeting.end_meeting
            if curr_meeting.save
                redirect_to(action: :admin_dashboard, notice: "Meeting Sign-in Ended.") and return
            end
            redirect_to(action: :admin_dashboard, notice: "Couldn't save meeting sign-in ended.") and return
        end
        redirect_to(action: :admin_dashboard, notice: "There is no meeting sign-in occuring.") and return
    end

    def sign_into_meeting
        user = current_user
        curr_meeting = Meeting.get_current_meeting
        unless curr_meeting.nil?
            record = AttendanceRecord.find_record(curr_meeting, user)
            unless record.nil?
                record.attended = true
                if record.save
                    redirect_to(action: :user_dashboard, notice: "Signed into Meeting.") and return
                else
                    redirect_to(action: :user_dashboard, notice: "Attendance record couldn't be saved.") and return
                end
            end
            redirect_to(action: :user_dashboard, notice: "User is not signed up for this meeting.") and return
        end
        redirect_to(action: :user_dashboard, notice: "Meeting sign in period has already ended.") and return
    end

end
