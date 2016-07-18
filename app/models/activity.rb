class Activity < ActiveRecord::Base
  belongs_to :product_backlog
  belongs_to :sprint
  belongs_to :user
  belongs_to :assignee
  has_one :work_performance

  has_many :log_works
  after_create :create_log_works, :create_work_performance

  scope :of_product_backlog_and_sprint, ->product_backlog_id, sprint_id do
    where product_backlog_id: product_backlog_id, sprint_id: sprint_id
  end
  scope :fitler_log_works, ->sprint{includes(:log_works).where(sprint: sprint)}

  delegate :plan, :actual, :spent_hour, :burned_hour, :estimated_story,
    :burned_story, :estimated_task, to: :work_performance, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true

  def get_remaining_activity
    self.log_works.any? ? self.log_works.pluck(:remaining_time).min : 0
  end

  private
  def create_log_works
    self.sprint.master_sprints.each do |master_sprint|
      master_sprint.log_works.create remaining_time: 0,
        sprint: sprint, activity: self
    end
  end

  def create_work_performance
    WorkPerformance.create activity: self, phase: Phase.first
  end
end


