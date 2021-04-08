# frozen_string_literal: true

# an Excuse. has one attendance_record
class Excuse < ApplicationRecord
  belongs_to :attendance_record, inverse_of: :excuse
  enum status: { Pending: 0, Approved: 1, Rejected: 2 }
end
