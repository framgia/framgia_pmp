class Api::ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:status].nil?
      @projects = current_user.projects.is_not_closed
    else
      @projects = current_user.projects.is_closed
    end
    respond_to do |format|
      format.json do
        render json: {
          content: render_to_string(
            partial: "/projects/view_projects_closed", formats: "html",
              layout: false
          ), projects: @projects
        }
      end
    end
  end

  def show
    @users = User.not_in_project(@project.members.pluck(:user_id))
      .search(params[:term])
    @members_to_add = @users.map do |user|
      {id: user.id, label: user.name, value: user.name}
    end
    respond_to do |format|
      format.json do
        render json: @members_to_add
      end
    end
  end
end
