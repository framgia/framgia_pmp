class CheckWorkPerformanceExisted
  def initialize sprint, params
    @sprint = sprint
    @params = params
  end

  def check_wpd_if_existed
    check_wpd_existed
  end

  private
  def check_wpd_existed
    if @params[:master_sprint_id] && @params[:task_id]
      master_sprint_id = @params[:master_sprint_id]
      task_id = @params[:task_id]
      phase_id = @params[:phase_id]
      work_performances = @sprint.work_performances
        .of_activity_in_day(master_sprint_id, task_id, phase_id)
    end
    work_performances
  end
end
