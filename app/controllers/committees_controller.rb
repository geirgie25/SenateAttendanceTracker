# frozen_string_literal: true

class CommitteesController < ApplicationController
  skip_before_action :user_authorized, only: %i[show]
  skip_before_action :admin_authorized, only: %i[show edit update]

  # shows the current committee
  def show
    @committee = Committee.find(params[:id])
  end

  def edit
    @committee = Committee.find(params[:id])
    redirect_to(committee_path(@committee.id)) unless current_user&.heads_committee?(@committee) || current_user&.admin?
  end

  def update
    committee = Committee.find(params[:id])
    if current_user&.heads_committee?(committee) || current_user&.admin?
      committee.update(params[:committee].permit(:committee_name, user_ids: []))
    end
    redirect_to(committee_path(committee.id))
  end
end
