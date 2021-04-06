# frozen_string_literal: true

# AttendanceRecords helpers
module AttendanceRecordsHelper
  def show_excuse_link?(record)
    !record.attended && record.excuse.present?
  end

  # returns true if yellow absence warning should show
  def show_yellow_warning?(max_absences, current_absences)
    return true if current_absences >= (max_absences - max_absences / 4) && current_absences < max_absences

    false
  end

  # returns true if red absence warning should show
  def show_red_warning?(max_absences, current_absences)
    return true if current_absences >= max_absences

    false
  end
end
