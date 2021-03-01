class User < ApplicationRecord
  has_and_belongs_to_many :roles
  has_many :committee_enrollments, dependent: :delete_all
  has_many :committees, through: :committee_enrollments
  has_secure_password
  def is_admin
    return self.roles.find_by(role_name: "Administrator").present?
  end
  validates :username, uniqueness: true, presence: true
  validates :password, presence: true
end
