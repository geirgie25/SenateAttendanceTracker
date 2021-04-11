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

  # checks to see if user heads given committee
  def heads_committee?(committee)
    roles.any? { |role| role.committees.include?(committee) }
  end

  # checks to see if user is in given committee
  def in_committee?(committee)
    committees.include?(committee)
  end

  # checks to see if user attended given meeting
  def attended_meeting?(meeting)
    record = AttendanceRecord.find_record(meeting, self)
    record.nil? ? false : record.attended
  end

  validates :username, uniqueness: true, presence: true
  validates :password, presence: true
end
