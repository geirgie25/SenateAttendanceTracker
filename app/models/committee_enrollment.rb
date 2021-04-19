# frozen_string_literal: true

# a CommitteeEnrollment. has a user and a committee, as well as many attendance_records
class CommitteeEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :committee
  has_many :attendance_records, inverse_of: :committee_enrollment, dependent: :destroy

  def self.get_committee_enrollment(committee, user)
    where(user: user).and(where(committee: committee))
  end
end
