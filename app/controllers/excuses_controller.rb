# frozen_string_literal: true

class ExcusesController < ApplicationController
  skip_before_action :admin_authorized
  before_action :set_excuse, only: %i[show edit update destroy]
  before_action :user_id_authorized, only: %i[show]

  def index
    @meetings = Committee.find(params[:committee_id]).meetings
  end

  def my_excuses
    @absences = AttendanceRecord.get_absences(current_user)
  end

  def show
    @user = current_user
  end

  def new
    @excuse = Excuse.new
    @absence = AttendanceRecord.find(params[:attendance_record_id])
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
    return if current_user.id == @excuse.attendance_record.committee_enrollment.user.id

    redirect_back(fallback_location: '/excuses/my_excuses')
  end

  def set_excuse
    @excuse = Excuse.find(params[:id])
  end

  def excuse_params
    params.require(:excuse).permit(:reason, :status)
  end
end
