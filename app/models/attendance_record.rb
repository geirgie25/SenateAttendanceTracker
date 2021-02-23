class AttendanceRecord < ApplicationRecord
  belongs_to :meeting, inverse_of: :attendance_records
  belongs_to :committee_enrollment, inverse_of: :attendance_records
  has_many :excuses, inverse_of: :attendance_record
end