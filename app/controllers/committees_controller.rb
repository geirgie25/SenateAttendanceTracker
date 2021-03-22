
# frozen_string_literal: true

class CommitteesController < ApplicationController
  skip_before_action :user_authorized, only: %i[show]
  skip_before_action :admin_authorized, only: %i[show]
  def index
      @committees = Committee.all
  end

  def new
    @committee = Committee.new
  end

  def create
    @committee = Committee.new(committee_params)
    if @committee.save
        respond_to do |format|
            if @committee.save
                format.html{flash[:notice] = "Committee Created Successfully"}
                format.json{redirect_to(committees_path)}
            else
               format.html {render('new')}
               format.json { render :show, status: :created, location: @committee }
            end
  end
  # shows the current committee
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
