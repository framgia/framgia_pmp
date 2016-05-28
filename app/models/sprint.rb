class Sprint < ActiveRecord::Base
  belongs_to :project

  has_many :assignees
  has_many :users, through: :assignees
  has_many :product_backlogs
  has_many :activities
  has_many :time_logs
  has_many :log_works
  has_many :master_sprints

  SPRINT_ATTRIBUTES_PARAMS = [:name, :description, :project_id, :start_date, :work_day,
    user_ids: [], time_logs_attributes: [:id, :assignee_id, :lost_hour, :work_date],
    log_works_attributes: [:id, :activity_id, :remaining_time, :day],
    activities_attributes: [:id, :product_backlog_id, :subject, :description,
      :spent_time, :estimate, :user_id, :sprint_id]]

  scope :list_by_user, ->user do
    joins(:assignees).where assignees: {user_id: user.id}
  end

  accepts_nested_attributes_for :time_logs
  accepts_nested_attributes_for :log_works
  accepts_nested_attributes_for :activities
end
