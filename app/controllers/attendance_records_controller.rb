# frozen_string_literal: true

# controls attendance records. temp
class AttendanceRecordsController < ApplicationController
  skip_before_action :user_authorized, only: %i[index]
  skip_before_action :admin_authorized, only: %i[index]

  def index
    set_records
  end

  private

  def set_records
    @records = AttendanceRecord.all
    @records = @records.user(params[:user_id]) if params[:user_id]
    @records = @records.for_committee(params[:committee_id]) if params[:committee_id]
    @records = @records.for_meeting(params[:meeting_id]) if params[:meeting_id]
  end
end
