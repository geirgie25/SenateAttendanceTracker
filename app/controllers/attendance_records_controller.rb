# frozen_string_literal: true

# controls attendance records. temp
class AttendanceRecordsController < ApplicationController
  skip_before_action :user_authorized, only: %i[index]
  skip_before_action :admin_authorized, only: %i[index]

  def filtered_records
    @records = AttendanceRecord.in_committee(params[:committee_id])
  end

  def index
    @records = AttendanceRecord.all
    @records = @records.user(params[:user_id]) if params[:user_id]
    @records = @records.in_committee(params[:committee_id]) if params[:committee_id]
    puts @records
  end
end
