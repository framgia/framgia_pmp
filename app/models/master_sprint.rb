class MasterSprint < ActiveRecord::Base
  belongs_to :sprint

  has_many :time_logs
  has_many :log_works
  belongs_to :sprint

  before_create :set_date_and_day
  after_create :create_log_times_and_log_works

  def is_today?
    self.date.day == Time.now.day
  end

  private
  def create_log_times_and_log_works
    sprint.assignees.each do |assignee|
      assignee.time_logs.create master_sprint: self,
        work_date: date, sprint: sprint
    end

    sprint.activities.each do |activity|
      activity.log_works.create master_sprint: self,
        remaining_time: 0, day: day, sprint: sprint
    end
  end

  def set_date_and_day
    if sprint.master_sprints.count == 0
      self.day = 1
      self.date = sprint.start_date
    else
      self.day = sprint.master_sprints.size + 1
      self.date = sprint.master_sprints.last.date + 1
    end
  end
end
