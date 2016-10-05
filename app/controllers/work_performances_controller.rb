class WorkPerformancesController < ApplicationController
  load_resource
  load_resource :project
  load_resource :sprint

  def index
    @sprints = Sprint.list_by_user current_user
    @activities = @sprint.activities
  end

  def new
    @work_performances = []
    @sprint.item_performances.each do |item|
      @work_performances << item.work_performances.build
    end
    respond_to do |format|
      format.json {render json: {wpd_content: render_to_string(partial: "work_performances/form",
        locals: {project: @project, sprint: @sprint, work_performance: @work_performance,
          work_performances: @work_performances},
        layout: false,
        formats: "html")
      }}
    end
  end

  def create
    @work_performances = params[:work_performances].map do |wpd|
      WorkPerformance.new wpd.merge(params[:work_performance]).permit WorkPerformance::ATTRIBUTES_PARAMS
    end
    respond_to do |format|
      if @work_performances.map!(&:save)
        format.html {redirect_to project_sprint_work_performances_path @project, @sprint}
        format.json {render json: {}}
      else
        format.json {render json: @customer.errors.full_messages,
          status: :unprocessable_entity}
      end
    end
  end

  def update
    params[:work_performances].map do |wpd|
      @work_performance = WorkPerformance.find_by id: wpd[:id]
      @work_performance.update_attributes activity_id: params[:work_performance][:activity_id],
        master_sprint_id: params[:work_performance][:master_sprint_id],
        performance_value: wpd[:performance_value]
    end
    respond_to do |format|
      format.html {redirect_to project_sprint_work_performances_path @project, @sprint}
      format.json {head :no_content}
    end
  end

  private
  def work_performance_params
    params.permit WorkPerformance::ATTRIBUTES_PARAMS
  end
end
