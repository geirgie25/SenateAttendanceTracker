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
    committee.update(params[:committee].permit(:committee_name, user_ids: []))
    redirect_to(committee_path(committee.id))
  end
end
