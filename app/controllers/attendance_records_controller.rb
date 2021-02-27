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

    def sign_into_meeting
        curr_meeting = Meeting.get_current_meeting
        unless curr_meeting.nil?

        end
    end
end
