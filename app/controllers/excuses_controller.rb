# frozen_string_literal: true

class ExcusesController < ApplicationController
  skip_before_action :admin_authorized, only: %i[index my_excuses show new create destroy]
  before_action :set_excuse, only: %i[show edit update]

  def index
    @excuses = Excuse.all
  end

  def my_excuses
    @absences = AttendanceRecord.get_absences(current_user)
  end

  def show; end

  def new
    @excuse = Excuse.new
    @absence = AttendanceRecord.find(params[:attendance_record_id])
  end

  def edit; end

  def create
    @absence = AttendanceRecord.find(params[:excuse][:attendance_record_id])
    @excuse = Excuse.new(excuse_params)
    @excuse.attendance_record = @absence

    respond_to do |format|
      if @excuse.save
        format.html { redirect_to @excuse, notice: 'Excuse was successfully created.' }
        format.json { render :show, status: :created, location: @excuses }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @excuse.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @excuse.update(excuse_params)
        format.html { redirect_to @excuse, notice: 'Excuse was successfully updated.' }
        format.json { render :show, status: :ok, location: @excuse }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @excuse.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_excuse
    @excuse = Excuse.find(params[:id])
  end

  def set_record
    @absence = AttendanceRecord.find(params[:attendance_record_id])
  end

  def excuse_params
    params.require(:excuse).permit(:reason)
  end
end
