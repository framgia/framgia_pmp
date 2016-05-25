class SprintsController < ApplicationController
  load_resource
  load_resource :project
  before_action :load_sprint, :load_activities

  def show
    all_log_works = @activities.first.log_works if @activities.any?
    @log_works_count = all_log_works.size rescue 0
    if @sprint.time_logs.empty?
      @sprint.work_day.times do |work_date|
        @sprint.assignees.each do |assignee|
          @sprint.time_logs.build work_date: work_date, assignee: assignee
        end
      end
    end

    @estimate = EstimateLogworkService.new @activities, @sprint
    @log_estimates = @estimate.sum_remaining_for_day all_log_works
  end

  def update
    if @sprint.update_attributes sprint_params
      flash[:success] = flash_message "updated"
      redirect_to project_sprint_path(@project, @sprint)
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  private
  def sprint_params
    params.require(:sprint).permit Sprint::SPRINT_ATTRIBUTES_PARAMS
  end

  def load_sprint
    @sprints = Sprint.list_by_user current_user
  end

  def load_activities
    @activities = Activity.fitler_log_works @sprint
  end
end
