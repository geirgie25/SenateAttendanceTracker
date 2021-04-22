# frozen_string_literal: true

class CommitteesController < ApplicationController
  skip_before_action :user_authorized, only: %i[show]
  skip_before_action :admin_authorized, only: %i[show]

  def new
    @committee = Committee.new
  end

  def create
    @committee = Committee.create(params[:committee].permit(:committee_name, user_ids: []))
    @committee.roles << Role.create(role_name: "#{@committee.committee_name} Head")
    redirect_to admin_dashboards_path
  end

  def show
    @committee = Committee.find(params[:id])
  end

  def edit
    @committee = Committee.find(params[:id])
  end

  def update
    committee = Committee.find(params[:id])
    del_records(committee, params[:committee][:user_ids].map(&:to_i)) unless params[:committee][:user_ids].nil?
    committee.update(params[:committee].permit(:committee_name, :max_unexcused_absences,
                                               :max_excused_absences, :max_combined_absences, user_ids: []))
    redirect_to(committee_path(committee.id))
  end

  def destroy
    committee = Committee.find(params[:id])
    committee.committee_enrollments.destroy_all
    committee.roles.destroy_all
    committee.meetings.destroy_all
    committee.destroy
    redirect_to admin_dashboards_path
  end

  private

  def del_records(committee, u_ids)
    committee.users.each do |user|
      user.get_committee_enrollment(committee).attendance_records.destroy_all unless user.id.in?(u_ids)
    end
  end
end
