class User < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :committee_enrollments
  has_many :committees, through: :committee_enrollments
end