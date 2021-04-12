# frozen_string_literal: true

# controller for users
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :user_authorized, only: %i[index show]
  skip_before_action :admin_authorized, only: %i[index show edit update]
  before_action :user_id_authorized, only: %i[edit update]
  wrap_parameters :user, include: [:name, :username, :password, role_ids: []]

  # shows group of users
  def index
    set_users
  end

  # shows information for one user
  def show; end

  # makes new user
  def new
    @user = User.new
  end

  # makes changes to existing user
  def edit
    if current_user.id == @user.id
      render :user_edit
    elsif current_user.admin?
      render :admin_edit
    end

  end

  # assigns parameters and creates relations for new user
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        @committee = Committee.get_committee_by_name('General')
        @committee_enrollment = CommitteeEnrollment.new(user: @user, committee: @committee).save
        add_to_committee_if_head(@user)
        format.html { redirect_to users_path, notice: 'Senator was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # applies changes to existing user
  def update
    respond_to do |format|
      if @user.update(user_params)
        add_to_committee_if_head(@user)
        format.html { redirect_to users_path, notice: 'Senator was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        if current_user.id == @user.id
          format.html { render :user_edit, status: :unprocessable_entity }
        elsif current_user.admin?
          format.html { render :admin_edit, status: :unprocessable_entity }
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # deletes existing user
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Senator was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # sets excuse to corresponding user
  def set_user
    @user = User.find(params[:id])
  end

  # only allows certain parameters for user
  def user_params
    params.require(:user).permit(:name, :username, :password, role_ids: [])
  end

  # sets group of users depending on parameters given
  def set_users
    @users = User.all
    @committee = Committee.find(params[:committee_id]) if params[:committee_id]
    @users = @users.for_committee(@committee.id) if @committee
    return unless params[:max_user_absences] && @committee

    @list = []
    @users.each do |user|
      @list.push(user) if user.above_max_absences?(@committee)
    end
    @users = @list
  end

  # checks to see if user id matches before giving user permission
  def user_id_authorized
    if current_user.admin?
      nil
    else
      return if current_user.id == @user.id

      redirect_back(fallback_location: user_dashboards_path)
    end
  end

  # creates committee enrollment (if nonexistent) if user is comittee head
  def add_to_committee_if_head(user)
    Committee.joins(:roles).where(roles: user.roles).find_each do |committee|
      if CommitteeEnrollment.where(user: user).and(CommitteeEnrollment.where(committee: committee)).blank?
        CommitteeEnrollment.new(user: user, committee: committee).save
      end
    end
  end
end
