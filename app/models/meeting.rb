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
    return meeting_started && !meeting_ended
  end

  # starts this meeting
  def start_meeting
    unless meeting_started
        self[:start_time] = Time.now
        return true
    end
    return false
  end

  # ends this meeting
  def end_meeting
    if currently_meeting
        self[:end_time] = Time.now
        return true
    end
    return false
  end

  # gets a meeting that is currently happening
  def self.get_current_meeting
    return self.where(end_time: nil).and(self.where.not(start_time: nil)).take
  end
end