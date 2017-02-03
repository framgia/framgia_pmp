class RowsController < ApplicationController
  def create
    @sprint = Sprint.find_by id: params[:sprint_id]
    @task = @sprint.tasks.build
    @product_backlogs = @sprint.product_backlogs
    @project = Project.find_by id: @sprint.project_id

    if @task.save
      @assignees = @sprint.assignees.can_get_task
      @row_number = @sprint.tasks.size - 1
      @master_sprints = @sprint.master_sprints.order(day: :asc)
      @log_work_count = @sprint.log_works.size
      create_work_performance @sprint, @task
    end

    respond_to do |format|
      format.js
      format.json do
        render json: {
          content: render_to_string(
            partial: "row", formats: "html", layout: false
          ), row_number: @row_number
        }
      end
    end
  end

  def show
    @task = Task.find params[:id]
    @work_performance = WorkPerformance.new
    if @task.present?
      respond_to do |format|
        format.html do
          render partial: "sprints/dialog",
            locals: {task: @task, work_performance: @work_performance,
              sprint: @task.sprint}
        end
      end
    end
  end

  def destroy
    @tasks = Task.find_with_ids params[:task_ids]
    @tasks.destroy_all
    respond_to do |format|
      format.html{redirect_to project_sprint_path(@project)}
      format.json{head :no_content}
    end
  end

  private
  def create_work_performance sprint, task
    sprint.phases.each do |phase|
      sprint.master_sprints.each do |day|
        WorkPerformance.create phase_id: phase.id, sprint_id: sprint.id,
          task_id: task.id, item_performance_id: 6, master_sprint_id: day.id,
          performance_value: 0
      end
    end
  end
end
