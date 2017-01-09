class WorkPerformance < ActiveRecord::Base
  belongs_to :phase
  belongs_to :task
  belongs_to :item_performance
  belongs_to :sprint
  belongs_to :master_sprint
  belongs_to :product_backlog
  has_one :user, through: :task

  validates :performance_value, presence: true, numericality: {only_float: true,
    greater_than_or_equal_to: 0}

  ATTRIBUTES_PARAMS = [:task_id, :sprint_id, :master_sprint_id,
    :item_performance_id, :performance_value, :phase_id]

  scope :performances_in_day, ->(item_id, day) do
    where item_performance_id: item_id, master_sprint_id: day.id
  end
  scope :of_activity_in_day, ->(master_sprint_id, task_id, phase_id) do
    where master_sprint_id: master_sprint_id, task_id: task_id,
      phase_id: phase_id
  end
  scope :of_user_in_day, ->(user, master_sprint) do
    where user_id: user.id, master_sprint_id: master_sprint.id
  end
  scope :of_user_in_day_by_item, ->(user_id, task_id, day_id, item_id) do
    where user_id: user_id, task_id: task_id,
    master_sprint_id: day_id, item_performance_id: item_id
  end
  scope :in_day, ->(phase, day) do
    where phase_id: phase.id, master_sprint_id: day.id
  end
  scope :of_task_in_day, ->(task_id, day_id, item_id) do
    where task_id: task_id,
    master_sprint_id: day_id, item_performance_id: item_id
  end
  scope :of_story_in_day, ->(product_backlog_id, day_id, item_id) do
    where product_backlog_id: product_backlog_id,
      master_sprint_id: day_id,  item_performance_id: item_id
  end

  def item_performance_name
    phase_item = PhaseItem.find_by phase_id: self.phase_id,
      item_performance_id: self.item_performance_id
    phase_item.alias
  end
end
