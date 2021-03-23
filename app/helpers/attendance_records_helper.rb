# frozen_string_literal: true

# AttendanceRecords helpers
module AttendanceRecordsHelper
    def show_excuse_link?(record)
        !record.attended && record.excuses.count = 0
    end

end
