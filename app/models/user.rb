# frozen_string_literal: true

# a user. has many roles and committee_enrollments
class User < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :committee_enrollments, dependent: :delete_all
  has_many :committees, through: :committee_enrollments
  has_secure_password
  def admin?
    roles.find_by(role_name: 'Administrator').present?
  end
  validates :username, uniqueness: true, presence: true
  validates :password, presence: true
end
