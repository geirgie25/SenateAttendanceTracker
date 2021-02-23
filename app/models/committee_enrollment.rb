class CommitteeEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :committee
  has_many :attendance_records, inverse_of: :committee_enrollment
end