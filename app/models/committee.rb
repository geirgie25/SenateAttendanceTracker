class Committee < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :committee_enrollments
  has_many :users, through: :committee_enrollments
  has_many :meetings, inverse_of: :committee
end