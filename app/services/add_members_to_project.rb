class AddMembersToProject
  def initialize project, params
    @project = project
    @params = params
  end

  def create
    @members = @params[:users].map do |member|
      @params[:user_id] = member.last[:user_id]
      @params[:user_name] = member.last[:user_name]
      @project.members.build member_params
    end
    @members.map(&:save)
    @members
  end

  private
  def member_params
    @params.permit :user_name, :user_id, :project_id, :role
  end
end
