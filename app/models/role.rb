# frozen_string_literal: true

# a Role. has many users, has many committees
class Role < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :committees
end
