class MasterSprint < ActiveRecord::Base
  has_many :time_logs
  has_many :log_works
  belongs_to :sprint

  before_create :set_date_and_day
  after_create :create_log_times_and_log_works

  private
  def create_log_times_and_log_works
    sprint.assignees.each do |assignee|
      assignee.time_logs.create master_sprint: self
    end

    sprint.activities.each do |activity|
      activity.log_works.create master_sprint: self, remaining_time: 0
    end
  end

  def set_date_and_day
    if sprint.master_sprints.count == 0
      self.day = 1
      self.date = sprint.start_date
    else
      self.day = sprint.master_sprints.size + 1
      self.date = sprint.start_date + sprint.master_sprints.size.days
    end
  end
end
