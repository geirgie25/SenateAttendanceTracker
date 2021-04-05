# frozen_string_literal: true

# controls attendance records. temp
class AttendanceRecordsController < ApplicationController
  skip_before_action :admin_authorized, only: %i[index]

  def index
    @records = AttendanceRecord.records(current_user)
  end
end
