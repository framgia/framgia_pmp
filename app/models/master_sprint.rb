class MasterSprint < ActiveRecord::Base
  belongs_to :sprint

  has_many :time_logs
  has_many :log_works
  has_many :work_performances

  before_create :set_date_and_day
  after_create :create_log_times_and_log_works

  scope :in_today, ->{where date: Date.today}

  private
  def create_log_times_and_log_works
    sprint.assignees.each do |assignee|
      assignee.time_logs.create master_sprint: self, sprint: sprint
    end

    sprint.activities.each do |activity|
      activity.log_works.create master_sprint: self,
        remaining_time: activity.log_works.last.remaining_time, sprint: sprint
    end
  end

  def set_date_and_day
    if sprint.master_sprints.count == 0
      self.day = 1
      self.date = sprint.start_date
    else
      self.day = sprint.master_sprints.size + 1
      self.date = sprint.master_sprints.last.date + 1 if self.date.nil?
    end
  end
end
