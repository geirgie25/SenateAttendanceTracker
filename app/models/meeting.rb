# frozen_string_literal: true

# meeting model. each meeting has a committee and many attendance_records
class Meeting < ApplicationRecord
  belongs_to :committee, inverse_of: :meetings
  has_many :attendance_records, inverse_of: :meeting
  accepts_nested_attributes_for :attendance_records

  def meeting_started?
    !self[:start_time].nil?
  end

  def meeting_ended?
    !self[:end_time].nil?
  end

  def currently_meeting?
    meeting_started? && !meeting_ended?
  end

  # gets a meeting that is currently happening
  def self.current_meeting
    where(end_time: nil).and(where.not(start_time: nil)).take
  end

  def user_exists?(user)
    !AttendanceRecord.find_record(self, user).nil?
  end

  def attended_meeting?(user)
    record = AttendanceRecord.find_record(self, user)
    record.nil? ? false : record.attended
  end
end
