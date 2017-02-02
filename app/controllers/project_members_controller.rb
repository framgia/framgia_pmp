class ProjectMembersController < ApplicationController
  load_resource
  load_resource :project

  def create
    @members = AddMembersToProject.new(@project, params).create
    respond_to do |format|
      format.json do
        render json: {
          content: render_to_string(
            partial: "/projects/new_member_row", formats: "html", layout: false,
            locals: {row_number: @project.members.size, members: @members}
          )
        }
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: {
          current_role: @project_member[:role],
          project_roles: ProjectMember.roles.keys
        }
      end
    end
  end

  def update
    if @project_member.update_attributes role: params[:role].to_i
      respond_to do |format|
        format.json do
          render json: {new_role: @project_member.role}
        end
      end
    end
  end

  def destroy
    if @project_member.destroy
      respond_to do |format|
        format.json do
          render json: {
            user_id: @project_member.user_id,
            user_name: @project_member.user_name
          }
        end
      end
    end
  end

  private
  def member_params
    params.permit :user_name, :user_id, :project_id, :role
  end
end
