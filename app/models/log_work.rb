class LogWork < ActiveRecord::Base
  include UpdatePerformance

  belongs_to :task
  belongs_to :master_sprint
  belongs_to :sprint
  belongs_to :product_backlog
  after_update :update_actual_time, :update_remaining_time,
    :update_performance_of_spent_time, :update_performance_of_burn_story

  private
  def update_actual_time
    product_backlog = task.product_backlog
    if product_backlog
      actual_time = calculate_time product_backlog.id, sprint_id, :actual_time
      product_backlog.update_attributes actual: actual_time
    end
  end

  def update_remaining_time
    product_backlog = task.product_backlog
    if product_backlog
      remaining = calculate_time product_backlog.id, sprint_id, :remaining_time
      product_backlog.update_attributes remaining: remaining
    end
  end

  def calculate_time backlog_id, sprint_id, type
    tasks = Task.includes(:log_works).of_product_backlog_and_sprint(backlog_id,
      sprint_id)
    case type
    when :actual_time
      tasks.map(&:actual_time).reduce(0, :+)
    when :remaining_time
      tasks.map(&:remaining_time).reduce(0, :+)
    end
  end
end
