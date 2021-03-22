class ExcusesController < ApplicationController
  skip_before_action :admin_authorized, only: %i[index show new create destroy]
  before_action :set_excuse, only: %i[ show edit update]

  def index
    @absences = AttendanceRecord.get_absences(current_user)
  end

  def show; end

  def new
    @excuse = Excuse.new
    @absence = AttendanceRecord.find(params[:attendance_record_id])
    @excuse.build_attendance_record
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

  def destroy
    @absence = AttendanceRecord.find(params[:id])
    @excusess = @absence.excuses
    if @excuse.exists?
      @excuse.destroy
      respond_to do |format|
        format.html { redirect_to excuses_url, notice: 'Excuse was successfully deleted.' }
        format.json { head :no_content }
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
