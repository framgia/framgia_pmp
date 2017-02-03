class ProductBacklogsController < ApplicationController
  load_resource
  load_resource :project

  def index
    @sprints = @project.sprints
    @product_backlogs = @project.product_backlogs
    @users = User.all
    @training_management_presenters = ProductBacklogPresenter.new(@users).render
  end

  def create
    @sprints = @project.sprints
    @product_backlog = @project.product_backlogs.build
    @row_number = @project.product_backlogs.size.pred if @product_backlog.save

    respond_to do |format|
      format.json do
        render json: {
          row_number: @row_number,
          content: render_to_string(
            partial: "product_backlogs/row",
            layout: false,
            formats: "html"
          )
        }
      end
    end
  end

  def destroy
    @product_backlogs = ProductBacklog.with_ids params[:ids]
    @product_backlogs.destroy_all
    respond_to do |format|
      format.html{redirect_to project_product_backlogs_path(@project)}
      format.json{render json: {}}
    end
  end
end
