class Admin::TimeLogsController < ApplicationController
  before_action :load_sprint, :load_project
  
  def create
    update_lost_hour
    redirect_to admin_project_sprint_path @project, @sprint
  end

  private
  def update_lost_hour
    byebug
    @sprint.assignees.each_with_index do |assignee, row|
      Settings.sprint.default_days.times do |col|
        params["#{row + 1}-#{col}"].nil? ? lost_hour = 0 :
          lost_hour = params["#{row + 1}-#{col}"].to_i
        @timelog = TimeLog.find_by sprint_id: @sprint.id, assignee_id: assignee.id,
          work_date: col

        if @timelog.nil?
          TimeLog.create sprint_id: @sprint.id, assignee_id: assignee.id,
            work_date: col, lost_hour: lost_hour
        else
          if @timelog.lost_hour != lost_hour
            @timelog.update_attributes lost_hour: lost_hour
          end
        end
      end
    end 
  end

  def load_sprint
    @sprint = Sprint.find_by id: params[:sprint_id]
  end

  def load_project
    @project = Project.find_by id: params[:project_id]
  end
end
