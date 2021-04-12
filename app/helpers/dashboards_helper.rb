# frozen_string_literal: true

module DashboardsHelper
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

  # gets a string for the total absences warning. if no warning, returns empty string
  def total_absence_string(cenroll)
    near_limit = "You are nearing the total absence limit for #{cenroll.committee.committee_name} Committee.\n"
    reached_limit = "You have reached the total absence limit for #{cenroll.committee.committee_name} Committee.\n"
    return near_limit if show_yellow_warning?(cenroll.committee.max_combined_absences,
                                              AttendanceRecord.find_total_absences(cenroll))
    return reached_limit if show_red_warning?(cenroll.committee.max_combined_absences,
                                              AttendanceRecord.find_total_absences(cenroll))

    ''
  end

  # gets a string for the unexcused absences warning. if no warning, returns empty string
  def unexcused_absence_string(cenroll)
    near_limit = "You are nearing the unexcused absence limit for #{cenroll.committee.committee_name} Committee.\n"
    reached_limit = "You have reached the unexcused absence limit for #{cenroll.committee.committee_name} Committee.\n"
    return near_limit if show_yellow_warning?(cenroll.committee.max_unexcused_absences,
                                              AttendanceRecord.find_total_unexcused_absences(cenroll))
    return reached_limit if show_red_warning?(cenroll.committee.max_unexcused_absences,
                                              AttendanceRecord.find_total_unexcused_absences(cenroll))

    ''
  end

  # gets a string for the excused absences warning. if no warning, returns empty string
  def excused_absence_string(cenroll)
    near_limit = "You are nearing the excused absence limit for #{cenroll.committee.committee_name} Committee.\n"
    reached_limit = "You have reached the excused absence limit for #{cenroll.committee.committee_name} Committee.\n"
    return near_limit if show_yellow_warning?(cenroll.committee.max_excused_absences,
                                              AttendanceRecord.find_total_excused_absences(cenroll))
    return reached_limit if show_red_warning?(cenroll.committee.max_excused_absences,
                                              AttendanceRecord.find_total_excused_absences(cenroll))

    ''
  end

  # returns true if we should show the modal that shows the warnings
  def show_modal?(cenroll)
    !unexcused_absence_string(cenroll).empty? ||
      !excused_absence_string(cenroll).empty? ||
      !total_absence_string(cenroll).empty?
  end
end
