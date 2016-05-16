class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @projects = Project.list_by_assignee current_user
  end

  def show
    @project = Project.find params[:id]
    @manager = @project.manager
    @assignees = Assignee.list_by_project @project
  end
end
