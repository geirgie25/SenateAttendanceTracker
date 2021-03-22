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
end
