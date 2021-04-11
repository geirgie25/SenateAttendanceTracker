# frozen_string_literal: true

# controller for users
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :user_authorized, only: %i[index show]
  skip_before_action :admin_authorized, only: %i[index show edit update]
  before_action :user_id_authorized, only: %i[edit update]

  def index
    set_users
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        add_to_committee_if_head(@user)
        @committee = Committee.get_committee_by_name('General')
        @committee_enrollment = CommitteeEnrollment.new(user: @user, committee: @committee).save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        add_to_committee_if_head(@user)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :username, :password, role_ids: [])
  end

  def set_users
    @users = User.all
    @committee = Committee.find(params[:committee_id]) if params[:committee_id]
    @users = @users.for_committee(@committee.id) if @committee
    if params[:max_user_absences]
      @list = []
      @users.each do |user|
        ce = CommitteeEnrollment.where(user: user).and(CommitteeEnrollment.where(committee: @committee))
        emax_excused_absences = AttendanceRecord.find_total_excused_absences(ce)
        cmax_total_absences = AttendanceRecord.find_total_absences(ce)
        umax_unexcused_absences = AttendanceRecord.find_total_absences(ce) - AttendanceRecord.find_total_excused_absences(ce)
        if @committee.max_excused_absences > emax_excused_absences
          @list.push(user)
        elsif @committee.max_total_absences > cmax_total_absences
          @list.push(user)
        elsif @committee.max_unexcused_absences > umax_unexcused_absences
          @list.push(user)
        end
      end
      @users = @list
    end
  end

  def user_id_authorized
    if current_user.admin?
      nil
    else
      return if current_user.id == @user.id

      redirect_back(fallback_location: user_dashboards_path)
    end
  end

  def add_to_committee_if_head(user)
    Committee.joins(:roles).where(roles: user.roles).find_each do |committee|
      if CommitteeEnrollment.where(user: user).and(CommitteeEnrollment.where(committee: committee)).blank?
        CommitteeEnrollment.new(user: user, committee: committee).save
      end
    end
  end
end
