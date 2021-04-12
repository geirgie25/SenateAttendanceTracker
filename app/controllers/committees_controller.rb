# frozen_string_literal: true

class CommitteesController < ApplicationController
  skip_before_action :user_authorized, only: %i[show]
  skip_before_action :admin_authorized, only: %i[show]

  # temporary committee to fill in form
  def new
    @committee = Committee.new
  end

  # actually creates the committee
  def create
    @committee = Committee.create(params[:committee].permit(:committee_name, user_ids: []))
    @committee.roles << Role.create(role_name: "#{@committee.committee_name} Head")
    redirect_to admin_dashboards_path
  end

  # shows a given committee
  def show
    @committee = Committee.find(params[:id])
  end

  # editing given committee
  def edit
    @committee = Committee.find(params[:id])
  end

  # updating the committee (post action)
  def update
    committee = Committee.find(params[:id])
    committee.update(params[:committee].permit(:committee_name, :max_unexcused_absences,
                                               :max_excused_absences, :max_combined_absences, user_ids: []))
    redirect_to(committee_path(committee.id))
  end
end
