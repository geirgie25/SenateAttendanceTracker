# frozen_string_literal: true

# controller for users
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :user_authorized, only: %i[index show]
  skip_before_action :admin_authorized, only: %i[index show]

  def index
    if params[:committee_id].present?
      @committee = Committee.find(params[:committee_id])
    else
      admin_authorized
    end
    @users = filter_usersrails
  end

  def show
    admin_authorized if params[:committee_id].blank?
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    @committee = Committee.get_committee_by_name('General')
    @committee_enrollment = CommitteeEnrollment.new(user: @user, committee: @committee).save
    respond_to do |format|
      if @user.save
        Committee.joins(:roles).where(roles: @user.roles).find_each do |committee|
          unless CommitteeEnrollment.where(user: @user).and(CommitteeEnrollment.where(committee: committee)).present?
            CommitteeEnrollment.new(user: @user, committee: committee).save
          end
        end
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
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

  def filter_users
    return Committee.find(params[:committee_id]).users if params[:committee_id].present?

    User.all
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :username, :password, role_ids: [])
  end
end
