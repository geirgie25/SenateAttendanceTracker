# frozen_string_literal: true

# AttendanceRecords helpers
module AttendanceRecordsHelper
  def show_excuse_link?(record)
    !record.attended && record.excuse.present?
  end

  def attendance_type_string(attendance_type)
    return 'In Person' if attendance_type == 'In_Person'
    return 'Not Attended' if attendance_type.nil?

    'Online'
  end
end
