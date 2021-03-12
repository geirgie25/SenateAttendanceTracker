# frozen_string_literal: true

# an AttendanceRecord. has a meeting, committee_enrollment, and excuses
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
    false
  end

  # returns the attendance record for a user attending the meeting
  # if no record is found, returns nil
  def self.find_record(meeting, user)
    ce = CommitteeEnrollment.where(committee_id: meeting.committee_id).and(
      CommitteeEnrollment.where(user_id: user.id)
    ).take
    return where(meeting_id: meeting.id).and(where(committee_enrollment_id: ce.id)).take unless ce.nil?

    nil
  end

  # makes all the attendance records for a meeting
  def self.make_records_for(meeting)
    CommitteeEnrollment.where(committee_id: meeting.committee_id).find_each do |enrollment|
      AttendanceRecord.create(committee_enrollment: enrollment, meeting: meeting, attended: false)
    end
  end

  # returns the total number of absences for a user
  def self.find_total_absences(user)
    where(committee_enrollment: user.committee_enrollments).and(where(attended: false)).count
  end

  def self.find_total_excused_absences(user)
    excuse_count = 0
    where(committee_enrollment: user.committee_enrollments).and(where(attended: false)).find_each do |record|
      excuse_count += record.excuses.count
    end
    excuse_count
  end
end
