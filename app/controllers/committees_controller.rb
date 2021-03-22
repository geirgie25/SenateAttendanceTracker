class CommitteesController < ApplicationController

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


end
