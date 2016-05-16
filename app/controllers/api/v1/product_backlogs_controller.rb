class Api::V1::ProductBacklogsController < Api::BaseController
  def index
    product_backlogs = load_project.product_backlogs
    projects = Project.all.select(:id, :name)
    product_backlog_rows_data = {
      projects: projects,
      rows: product_backlogs.map do |pb|
        {
          id: pb.id,
          data: [pb.priority, pb.estimate, pb.actual, pb.remaining, get_project_name(pb)]
        }
      end
    }
    respond_with product_backlog_rows_data
  end

  private
  def get_project_name pb
    pb.project.nil? ? "" : pb.project.name
  end

  def load_project
    Project.find params[:project_id]
  end
end
