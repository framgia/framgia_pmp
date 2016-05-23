class TimeLog < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :user
  belongs_to :assignee

  def count_day_of_sprint sprint
    sprint.assignees.first.time_logs.size
  end
end
