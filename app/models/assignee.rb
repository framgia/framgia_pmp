class Assignee < ActiveRecord::Base
  belongs_to :sprint, class_name: Sprint.name
  belongs_to :user
  belongs_to :project

  scope :list_by_project, ->project{where project_id: project.id}
  scope :not_assign_sprint, ->{where "sprint_id IS ?", nil}

  delegate :name, to: :user, prefix: true, allow_nil: true
end
