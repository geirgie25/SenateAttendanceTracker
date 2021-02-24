class Meeting < ApplicationRecord
  belongs_to :committee, inverse_of: :meetings
  has_many :attendance_records, inverse_of: :meeting
  def meeting_started
    return !self[:start_time].nil?
  end

  def meeting_ended
    return !self[:end_time].nil?
  end

  def currently_meeting
    return meeting_start && !meeting_ended
  end

  def start_meeting
    unless meeting_started
        self[:start_time] = Time.now
        return true
    end
    return false
  end

  def end_meeting
    if meeting_started && !meeting_ended
        self[:end_time] = Time.now
        return true
    end
    return false
  end

  def self.get_current_meeting
    return self.where(end_time: nil).and(self.where.not(start_time: nil)).take
  end
end