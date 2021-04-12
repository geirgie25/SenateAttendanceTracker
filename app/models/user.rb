# frozen_string_literal: true

# a user. has many roles and committee_enrollments
class User < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :committee_enrollments, dependent: :delete_all
  has_many :committees, through: :committee_enrollments
  has_secure_password
  scope :for_committee, ->(committee_id) { Committee.find(committee_id).users }
  def admin?
    roles.find_by(role_name: 'Administrator').present?
  end

  def heads_committee?(committee)
    roles.any? { |role| role.committees.include?(committee) }
  end

  def in_committee?(committee)
    committees.include?(committee)
  end

  def attended_meeting?(meeting)
    record = AttendanceRecord.find_record(meeting, self)
    record.nil? ? false : record.attended
  end

  def get_committee_enrollment(committee)
    CommitteeEnrollment.where(user: self).and(CommitteeEnrollment.where(committee: committee))
  end

  def above_max_absences?(committee)
    ce = get_committee_enrollment(committee)
    excused_absences = AttendanceRecord.find_total_excused_absences(ce)
    total_absences = AttendanceRecord.find_total_absences(ce)
    unexcused_absences = AttendanceRecord.find_total_absences(ce) - AttendanceRecord.find_total_excused_absences(ce)
    committee.max_excused_absences <= excused_absences ||
      committee.max_combined_absences <= total_absences ||
      committee.max_unexcused_absences <= unexcused_absences
  end

  validates :username, uniqueness: true, presence: true
  validates :password, presence: true
end
