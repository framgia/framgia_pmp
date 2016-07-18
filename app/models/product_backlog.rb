class ProductBacklog < ActiveRecord::Base
  belongs_to :project
  belongs_to :sprint

  has_many :activities

  delegate :name, to: :project, prefix: true
  delegate :name, :id, to: :sprint, prefix: true, allow_nil: true

  def total_estimation_time
    estimate = Activity.includes(:log_works)
      .of_product_backlog_and_sprint(id, sprint_id).map do |activity|
      activity.log_works.first.remaining_time
    end.sum rescue 0
    self.update_attributes estimate: estimate
    estimate
  end

  def total_remaining_time
    remaining = Activity.includes(:log_works)
      .of_product_backlog_and_sprint(id, sprint_id).map do |activity|
      activity.log_works.last.remaining_time
    end.sum rescue 0
    self.update_attributes remaining: remaining
    remaining
  end
end
