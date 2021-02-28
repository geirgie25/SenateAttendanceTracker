class AttendanceRecordsController < ApplicationController

    # we need to add verifications if a user loggedin/admin when will is done

    def index
        # these are temporary variables until we can actually get user information
        user = User.find(9)
        logged_in = true
        is_admin = true
        curr_meeting = Meeting.get_current_meeting
        if is_admin # if admin
            @show_start_meeting = curr_meeting.nil?
            @meetings = Meeting.all

            render :administrator
        elsif logged_in # if not admin but logged
            # FIXME: change to current user once login is figured out
            @user = User.first
            @total_absences = AttendanceRecord.find_total_absences(@user)
            @excused_absences = AttendanceRecord.find_total_excused_absences(@user)
            @unexcused_absences = @total_absences - @excused_absences
            @show_signin = !curr_meeting.nil? && curr_meeting.signed_up_for_meeting(user) && !curr_meeting.attended_meeting(user) 
            render :user
        else
            # redirect to login page
        end

    end

    def view_meeting
        # another temp variables

        logged_in = true
        is_admin = true

        if is_admin
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

    # starts meeting signin then redirects to index
    def start_meeting_signin
        admin = true
        if admin
            @committee = Committee.get_committee_by_name("General")
            if !@committee.nil?
                @meeting = Meeting.create(committee: @committee)
                @meeting.start_meeting
                puts @meeting.save
                if @meeting.save
                    AttendanceRecord.make_records_for(@meeting)
                    redirect_to(action: :index, notice: "Meeting Sign-in Started.") and return
                end
                redirect_to(action: :index, notice: "Couldn't save meeting sign-in.") and return
            end
            puts "Can't find committee General, was DB seeded?"
            redirect_to(action: :index, notice: "Couldn't find committee General.") and return
        end
        redirect_to(action: :index, notice: "Do not have permission for this action.") and return
    end

    # ends current meeting signin then redirects to index
    def end_meeting_signin
        admin = true
        if admin
            curr_meeting = Meeting.get_current_meeting
            unless curr_meeting.nil?
                curr_meeting.end_meeting
                if curr_meeting.save
                    redirect_to(action: :index, notice: "Meeting Sign-in Ended.") and return
                end
                redirect_to(action: :index, notice: "Couldn't save meeting sign-in ended.") and return
            end
            redirect_to(action: :index, notice: "There is no meeting sign-in occuring.") and return
        end
        redirect_to(action: :index, notice: "Do not have permission for this action.") and return
    end

    # signs user into current meeting then redirects to index page
    def sign_into_meeting
        user = User.find(9) # change to logged in user later
        signed_in = true
        if signed_in
            curr_meeting = Meeting.get_current_meeting
            unless curr_meeting.nil?
                record = AttendanceRecord.find_record(curr_meeting, user)
                unless record.nil?
                    record.attended = true
                    if record.save
                        redirect_to(action: :index, notice: "Signed into Meeting.") and return
                    else
                        redirect_to(action: :index, notice: "Attendance record couldn't be saved.") and return
                    end
                end
                redirect_to(action: :index, notice: "User is not signed up for this meeting.") and return
            end
            redirect_to(action: :index, notice: "Meeting sign in period has already ended.") and return
        end
        redirect_to(action: :index, notice: "Do not have permisison for this action.") and return
    end

end
