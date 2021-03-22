class CommitteesController < ApplicationController

    def index
        @committees = Committee.all
    end

    def new
      @committee = Committee.new
    end

    def edit
        @committee = Committee.find(params[:id])
    end

    def show
        @committee = Committe.find(params[:id])
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

    def update
        @committee = Committee.find(params[:id])
        respond_to do |format|
            if @committee.update(committee_params)
                format.html {flash[:notice] = "Committee Updated succsefully"}
                format.json {redirect_to(books_path)}
            else
                format.html{render('edit')}
            end
        end
    end

    def delete
        @committee = Committee.find(params[:id])

    end

    def destroy
        @committee = Committee.find(params[:id])
        @committee.destroy
        respond_to do |format|
        format.html { redirect_to committees_path, notice: 'Committee was successfully deleted.' }
        format.json { head :no_content }
    end
end

    def committee_params
      params.require(:committee).permit(:name)
    end
end
