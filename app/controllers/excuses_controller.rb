# frozen_string_literal: true

class ExcusesController < ApplicationController
  skip_before_action :admin_authorized
  before_action :set_excuse, only: %i[show edit update destroy]
  before_action :set_record, only: %i[new]
  before_action :committee_head_authorized, only: %i[index edit update destroy]
  before_action :user_id_authorized, only: %i[show new]
  before_action :user_only, only: %i[my_excuses create]

  def index
    @meetings = Committee.find(params[:committee_id]).meetings
    @records = AttendanceRecord.where(meeting: @meetings)
    @excuses = Excuse.where(attendance_record: @records)
  end

  def my_excuses
    @absences = AttendanceRecord.get_absences(current_user)
  end

  def show
    @user = current_user
  end

  def new
    @excuse = Excuse.new
  end

  def edit; end

  def create
    @absence = AttendanceRecord.find(params[:excuse][:attendance_record_id])
    @excuse = Excuse.new(excuse_params)
    @excuse.attendance_record = @absence
    @excuse.save
    redirect_to excuses_my_excuses_path
  end

  def update
    @excuse.update(excuse_params)
    redirect_to committee_path(@excuse.attendance_record.meeting.committee.id),
                notice: 'Excuse was successfully updated.'
  end

  def destroy
    @excuse.destroy
    respond_to do |format|
      format.html do
        redirect_to "/committees/#{@excuse.id}/excuses/", notice: 'Excuse was successfully deleted.'
      end
      format.json { head :no_content }
    end
  end

  private

  def user_id_authorized
    if @excuse.nil?
      return if current_user.id == @absence.committee_enrollment.user.id
    elsif current_user.id == @excuse.attendance_record.committee_enrollment.user.id
      return
    end
    redirect_back(fallback_location: excuses_my_excuses_path)
  end

  def committee_head_authorized
    if !Committee.find(params[:committee_id]).nil?
      @committee = Committee.find(params[:committee_id])
      return if current_user.heads_committee?(@committee)

      redirect_back(fallback_location: committee_path(@committee.id))
    elsif !@excuse.nil?
      return if current_user.heads_committee?(@excuse.attendance_record.meeting.committee)

      redirect_back(fallback_location: excuses_my_excuses_path)
    end
    redirect_back(fallback_location: excuses_my_excuses_path)
  end

  def user_only
    redirect_back(fallback_location: admin_dashboards_path) if current_user.admin?
  end

  def set_excuse
    @excuse = Excuse.find(params[:id])
  end

  def set_record
    @absence = AttendanceRecord.find(params[:attendance_record_id])
  end

  def excuse_params
    params.require(:excuse).permit(:reason, :status)
  end
end
