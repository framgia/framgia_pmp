class Admin::SprintsController < ApplicationController
  before_action :load_project
  before_action :load_assignee, only: [:new, :edit]
  before_action :load_sprint, except: [:new, :create]

  def new
    @sprint = Sprint.new
  end

  def create
    @sprint = Sprint.new sprint_params
    if @sprint.save
      flash[:success] = flash_message "created"
      redirect_to admin_project_path(@project)
    else
      flash[:failed] = flash_messages "not_created"
      render :new
    end
  end

  def update
    if @sprint.update_attributes sprint_params
      flash[:success] = flash_message "updated"
      redirect_to admin_project_sprint_path(@project, @sprint)
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @sprint.destroy
      flash[:success] = flash_message "deleted"
      redirect_to admin_project_path(@project)
    else
      flash[:failed] = flash_message "not_updated"
      redirect_to admin_project_sprint_path(@project, @sprint)
    end
  end

  private
  def load_assignee
    @assignees = @project.assignees.not_assign_sprint
  end

  def sprint_params
    params.require(:sprint).permit Sprint::SPRINT_ATTRIBUTES_PARAMS
  end

  def load_project
    @project = Project.find params[:project_id]
  end

  def load_sprint
    @sprint = Sprint.find params[:id]
  end
end
