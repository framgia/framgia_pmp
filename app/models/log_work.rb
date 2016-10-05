class LogWork < ActiveRecord::Base
  belongs_to :activity
  belongs_to :master_sprint
  belongs_to :sprint
  after_update :update_actual_time, :update_remaining_time

  private
  def update_actual_time
    product_backlog = activity.product_backlog
    actual_time = Activity.includes(:log_works)
      .of_product_backlog_and_sprint(product_backlog.id, sprint.id).map do |activity|
      activity.log_works.first.remaining_time
    end.sum rescue 0
    product_backlog.update_attributes actual: actual_time
  end

  def update_remaining_time
    product_backlog = activity.product_backlog
    remaining = Activity.includes(:log_works)
      .of_product_backlog_and_sprint(product_backlog.id, sprint.id).map do |activity|
      activity.log_works.last.remaining_time
    end.sum rescue 0
    product_backlog.update_attributes remaining: remaining
  end
end
