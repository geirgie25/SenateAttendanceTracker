class AttendanceRecord < ApplicationRecord
  belongs_to :meeting, inverse_of: :attendance_records
  belongs_to :committee_enrollment, inverse_of: :attendance_records
  has_many :excuses, inverse_of: :attendance_record

  # sets the attendance record for a user attending a meeting to value
  # returns true if an attendance record for the meeting was found
  # else returns false
  def self.set_attended(meeting, user, value)
    record = find_record(meeting, user)
    unless record.nil?
      record.attended = value
      record.save
      return true
    end
    return false
  end
  
  # returns the attendance record for a user attending the meeting
  # if no record is found, returns nil
  def self.find_record(meeting, user) 
    ce = CommitteeEnrollment.where(committee_id: meeting.committee_id).and(CommitteeEnrollment.where(user_id: user.id)).take
    unless ce.nil?
      return self.where(meeting_id: meeting.id).and(self.where(committee_enrollment_id: ce.id)).take
    end
    return nil
  end

end