# frozen_string_literal: true

# committee model. A committee has many roles, committee_enrollments, and meetings.
class Committee < ApplicationRecord
  validates :committee_name, presence: true
  has_and_belongs_to_many :roles
  has_many :committee_enrollments
  has_many :users, through: :committee_enrollments
  has_many :meetings, inverse_of: :committee

  def self.get_committee_by_name(name)
    find_by(committee_name: name)
  end

  def current_meeting?
    Meeting.where(committee: self).and(Meeting.where(end_time: nil)).exists?
  end

  def current_meeting
    Meeting.where(committee: self).and(Meeting.where(end_time: nil)).take
  end

  # returns max combined absences allowed for all user's committees combined
  def self.get_max_combined_absences_for_all_user_committees(user)
    total_max_combined_absences = 0
    where(committee_enrollments: user.committee_enrollments).find_each do |committee|
      total_max_combined_absences += committee.max_combined_absences
    end
    total_max_combined_absences
  end

  # returns max excused absences allowed for all user's committees combined
  def self.get_max_excused_absences_for_all_user_committees(user)
    total_max_excused_absences = 0
    where(committee_enrollments: user.committee_enrollments).find_each do |committee|
      total_max_excused_absences += committee.max_excused_absences
    end
    total_max_excused_absences
  end

  # returns max unexcused absences allowed for all user's committees combined
  def self.get_max_unexcused_absences_for_all_user_committees(user)
    total_max_unexcused_absences = 0
    where(committee_enrollments: user.committee_enrollments).find_each do |committee|
      total_max_unexcused_absences += committee.max_unexcused_absences
    end
    total_max_unexcused_absences
  end
end
