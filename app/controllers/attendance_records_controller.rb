class AttendanceRecordsController < ApplicationController
    
    def administrator
        # shows main view for the administrator
    end

    def user
        # shows view for that specific user
    end

    def view_meeting
        # shows a specific meeting to the administrator
    end

    def sign_into_meeting
        curr_meeting = Meeting.get_current_meeting
        unless curr_meeting.nil?

        end
    end
end
