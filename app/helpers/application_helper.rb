# frozen_string_literal: true

# default helper methods
module ApplicationHelper
  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end

  # returns true if the given user has committee head
  # permissions for the given committee
  def committee_head_permissions?(user, committee)
    return user.heads_committee?(committee) unless user.nil?

    false
  end

  def attendance_status_string(record)
    return 'Attended' if record.attended
    return 'Excused Absence' if record.excuse && record.excuse.status == 'Accepted'

    'Unexcused Absence'
  end

  def end_meeting_time_string(time)
    return 'Current' if time.nil?

    time.to_formatted_s(:short)
  end
end
