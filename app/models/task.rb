class Task < ActiveRecord::Base
  belongs_to :product_backlog
  belongs_to :sprint
  belongs_to :user
  belongs_to :assignee
  has_many :work_performances

  has_many :log_works, dependent: :destroy
  after_create :create_log_works

  scope :of_product_backlog_and_sprint, ->product_backlog_id, sprint_id do
    where product_backlog_id: product_backlog_id, sprint_id: sprint_id
  end
  scope :of_product_backlog, ->product_backlog_id do
    where product_backlog_id: product_backlog_id
  end
  scope :fitler_log_works, ->sprint{includes(:log_works).where(sprint: sprint)}
  scope :of_user_in_sprint, ->(user_id, sprint) do
    where user_id: user_id, sprint_id: sprint.id
  end
  scope :number_of_task, ->sprint_id{where sprint_id: sprint_id}
  scope :find_with_ids, ->ids{where id: ids}

  delegate :name, to: :user, prefix: true, allow_nil: true
  delegate :story, to: :product_backlog, prefix: true, allow_nil: true

  def get_remaining_activity
    self.log_works.any? ? self.log_works.pluck(:remaining_time).min : 0
  end

  def actual_time
    log_works.first.remaining_time
  end

  def remaining_time
    log_works.last.remaining_time
  end

  def estimate_time
    log_works.first.remaining_time
  end

  private
  def create_log_works
    self.sprint.master_sprints.each do |master_sprint|
      master_sprint.log_works.create remaining_time: 0,
        sprint: sprint, task: self
    end
  end
end
