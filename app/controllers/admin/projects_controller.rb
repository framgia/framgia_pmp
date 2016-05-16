class Admin::ProjectsController < ApplicationController
  before_action :load_assignee, only: [:new, :edit, :show]
  before_action :load_project, except: [:index, :new, :create]
  before_action :load_params, except: [:index, :create]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new project_params
    if @project.save
      flash[:success] = flash_message "created"
      redirect_to admin_root_url
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def show
    @manager = @project.manager
    @assignees = Assignee.list_by_project @project
  end

  def update
    if @project.update_attributes project_params
      flash[:success] = flash_message "updated"
      redirect_to admin_project_path(@project)
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:success] = flash_message "not_deleted"
    end
    redirect_to admin_root_path
  end

  private
  def project_params
    params.require(:project).permit Project::PROJECT_ATTRIBUTES_PARAMS
  end

  def load_assignee
    @users = User.all
    @assignee = Assignee.new
  end

  def load_project
    @project = Project.find params[:id]
  end
end
