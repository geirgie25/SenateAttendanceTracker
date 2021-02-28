class Excuse < ApplicationRecord
  belongs_to :attendance_record, inverse_of: :excuses
end