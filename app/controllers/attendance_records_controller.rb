class AttendanceRecordsController < ApplicationController
    
    # we need to add verifications if a user loggedin/admin when will is done

    def index
        # these are temporary variables until we can actually get user information
        logged_in = true
        is_admin = true

        if logged_in && is_admin # if admin
            render :administrator
        elsif logged_in # if not admin but logged in
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
            @meeting_id = params[:meeting_id]
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
                @meeting.save
                AttendanceRecord.make_records_for(@meeting)
                redirect_to("attendance_records#index", notice: "Meeting Sign-in Started.")
            end
            puts "Can't find committee General, was DB seeded?"
        end
        
        redirect_to("attendance_records#index", notice: "Do not have permission for this action.")
    end

    # ends current meeting signin then redirects to index
    def end_meeting_signin
        admin = true
        if admin
            curr_meeting = Meeting.get_current_meeting
            unless curr_meeting.nil?
                curr_meeting.end_meeting
                unless curr_meeting.save
                    redirect_to("attendance_records#index", notice: "Meeting Sign-in Ended.")
                end
                redirect_to("attendance_records#index", notice: "Couldn't save meeting sign-in ended.")
            end
            redirect_to("attendance_records#index", notice: "There is no meeting sign-in occuring.")
            puts "Can't find committee General, was DB seeded?"
        end
        redirect_to("attendance_records#index", notice: "Do not have permission for this action.")
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
                        redirect_to("attendance_records#index", notice: "Signed into Meeting.")
                    else
                        redirect_to("attendance_records#index", notice: "Attendance record couldn't be saved.")
                    end
                end
                redirect_to("attendance_records#index", notice: "User is not signed up for this meeting.")
            end
            redirect_to("attendance_records#index", notice: "Meeting sign in period has already ended.")
        end
        redirect_to("attendance_records#index", notice: "Do not have permisison for this action.")
    end
end
