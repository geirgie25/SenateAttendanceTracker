# frozen_string_literal: true

# an Excuse. has one attendance_record
class Excuse < ApplicationRecord
  belongs_to :attendance_record, inverse_of: :excuses
  enum status: [ :Pending, :Approved, :Rejected ]
end
