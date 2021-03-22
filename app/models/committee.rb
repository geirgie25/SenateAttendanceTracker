# frozen_string_literal: true

# committee model. A committee has many roles, committee_enrollments, and meetings.
class Committee < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :committee_enrollments
  has_many :users, through: :committee_enrollments
  has_many :meetings, inverse_of: :committee

  def self.get_committee_by_name(name)
    find_by(committee_name: name)
  end

  validates_presence_of :committee_name


  def current_meeting?
    Meeting.where(committee: self).and(Meeting.where(end_time: nil)).exists?
  end

  def current_meeting
    Meeting.where(committee: self).and(Meeting.where(end_time: nil)).take
  end

end
