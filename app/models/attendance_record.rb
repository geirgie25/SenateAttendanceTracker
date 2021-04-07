# frozen_string_literal: true

# an AttendanceRecord. has a meeting, committee_enrollment, and an excuse
class AttendanceRecord < ApplicationRecord
  belongs_to :meeting, inverse_of: :attendance_records
  belongs_to :committee_enrollment, inverse_of: :attendance_records
  has_one :excuse, inverse_of: :attendance_record

  scope :in_committee, ->(committee_id) { left_outer_joins(:meeting).where("meetings.committee_id = ?", committee_id) }
  scope :user, ->(user_id) { left_outer_joins(:committee_enrollment).where("committee_enrollments.user_id = ?", user_id)}
  # sets the attendance record for a user attending a meeting to value
  # returns true if an attendance record for the meeting was found
  # else returns false

  def self.set_attended(meeting, user, value)
    record = find_record(meeting, user)
    unless record.nil?
      record.attended = value
      return record.save
    end
    false
  end

  # returns the attendance record for a user attending the meeting
  # if no record is found, returns nil
  def self.find_record(meeting, user)
    ce = CommitteeEnrollment.where(committee: meeting.committee).and(
      CommitteeEnrollment.where(user: user)
    ).take
    return where(meeting: meeting).and(where(committee_enrollment: ce)).take unless ce.nil?

    nil
  end

  # makes all the attendance records for a meeting
  def self.make_records_for(meeting)
    CommitteeEnrollment.where(committee_id: meeting.committee_id).find_each do |enrollment|
      AttendanceRecord.create(committee_enrollment: enrollment, meeting: meeting, attended: false)
    end
  end

  # returns the total number of absences for a committee
  def self.find_total_absences(committee_enrollment)
    where(committee_enrollment: committee_enrollment).and(where(attended: false)).count
  end

  # returns the total number of excused absences for a user
  def self.find_total_excused_absences(committee_enrollment)
    excuse_count = 0
    where(committee_enrollment: committee_enrollment).and(where(attended: false)).find_each do |record|
      excuse_count += 1 if record.excuse.present?
    end
    excuse_count
  end

  # returns all attendance records for missed meetings for a user
  def self.get_absences(user)
    where(committee_enrollment: user.committee_enrollments).and(where(attended: false))
  end

  # gets all attendance records for user
  def self.records(user)
    where(committee_enrollment: user.committee_enrollments)
  end
end
