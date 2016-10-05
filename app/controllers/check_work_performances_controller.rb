class CheckWorkPerformancesController < ApplicationController
  def update
    if params[:master_sprint_id] && params[:activity_id]
      @sprint = Sprint.find_by id: params[:sprint_id]
      @master_sprint = MasterSprint.find_by id: params[:master_sprint_id]
      @activity = Activity.find_by id: params[:activity_id]
      @work_performances = @sprint.work_performances.of_activity_in_day(current_user,
        @master_sprint, @activity)
      respond_to do |format|
        if @work_performances.any?
          format.json {render json: {check: 1, wpds: @work_performances}}
        else
          format.json {render json: {check: 0, wpds: []}}
        end
      end
    end
  end
end
