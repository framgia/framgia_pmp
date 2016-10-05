class WorkPerformance < ActiveRecord::Base
  belongs_to :phase
  belongs_to :activity
  belongs_to :item_performance
  belongs_to :sprint
  belongs_to :master_sprint

  delegate :name, to: :item_performance, prefix: true, allow_nil: true
  validates :performance_value, presence: true

  ATTRIBUTES_PARAMS = [:activity_id, :sprint_id, :master_sprint_id,
    :item_performance_id, :assignee_id, :performance_value]

  scope :performances_in_day, ->(users_id, item, day) do
    where assignee_id: users_id, item_performance_id: item.id, master_sprint_id: day.id
  end
  scope :of_activity_in_day, ->(user, master_sprint, activity) do
    where assignee_id: user.id, master_sprint_id: master_sprint.id, activity_id: activity.id
  end
  scope :of_user_in_day, ->(user, master_sprint) do
    where assignee_id: user.id, master_sprint_id: master_sprint.id
  end

  scope :in_day, ->day{where master_sprint_id: day.id}
end
