# frozen_string_literal: true

class ExcusesController < ApplicationController
  skip_before_action :admin_authorized
  before_action :set_excuse, only: %i[show edit update destroy]
  before_action :set_record, only: %i[new]
  before_action :committee_head_authorized, only: %i[edit update destroy]
  before_action :user_id_authorized, only: %i[show new]
  before_action :user_only, only: %i[my_absences create]

  # shows group of excuses
  def index
    set_excuses
  end

  # shows current user's excuses
  def my_absences
    @absences = AttendanceRecord.get_absences(current_user)
  end

  # shows information for one excuse
  def show
    @user = current_user
  end

  # makes new excuse
  def new
    @excuse = Excuse.new
  end

  # makes changes to existing excuse
  def edit; end

  # assigns parameters and creates relations for new excuse
  def create
    @absence = AttendanceRecord.find(params[:excuse][:attendance_record_id])
    @excuse = Excuse.new(excuse_params)
    @excuse.attendance_record = @absence
    @excuse.save
    redirect_to excuses_my_absences_path
  end

  # applies changes to existing excuse
  def update
    @excuse.update(excuse_params)
    redirect_to committee_path(@excuse.attendance_record.meeting.committee.id),
                notice: 'Excuse was successfully updated.'
  end

  # deletes existing excuse
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

  # checks to see if user id matches before giving user permission
  def user_id_authorized
    if @excuse.nil?
      return if current_user.id == @absence.committee_enrollment.user.id
    elsif current_user.id == @excuse.attendance_record.committee_enrollment.user.id
      return
    end
    redirect_back(fallback_location: excuses_my_absences_path)
  end

  # checks to see if user is committee head before giving user permission
  def committee_head_authorized
    @committee = Committee.find_by(id: params[:committee_id])
    if @committee
      return if current_user.heads_committee?(@committee)

      redirect_back(fallback_location: committee_path(@committee.id))
    elsif @excuse.present?
      return if current_user.heads_committee?(@excuse.attendance_record.meeting.committee)

      redirect_back(fallback_location: excuses_my_absences_path)
    end
  end

  # checks to see if user is non-admin before giving user permission
  def user_only
    redirect_back(fallback_location: admin_dashboards_path) if current_user.admin?
  end

  # sets excuse to corresponding excuse
  def set_excuse
    @excuse = Excuse.find(params[:id])
  end

  # sets group of excuses depending on parameters given
  def set_excuses
    committee = Committee.find(params[:committee_id])
    if committee && current_user&.heads_committee?(committee)
      @meetings = committee.meetings
      @records = AttendanceRecord.where(meeting: @meetings)
      @excuses = Excuse.where(attendance_record: @records)
    else
      redirect_to excuses_my_absences_path
    end
  end

  # sets record to corresponding record
  def set_record
    @absence = AttendanceRecord.find(params[:attendance_record_id])
  end

  # only allows certain parameters for excuse
  def excuse_params
    params.require(:excuse).permit(:reason, :status)
  end
end
