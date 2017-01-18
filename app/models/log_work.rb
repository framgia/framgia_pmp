class LogWork < ActiveRecord::Base
  include UpdatePerformance

  belongs_to :task
  belongs_to :master_sprint
  belongs_to :sprint
  after_update :update_actual_time, :update_remaining_time,
    :update_performance_of_spent_time, :update_estimate_of_task

  private
  def update_actual_time
    if self == task.log_works.first
      product_backlog = task.product_backlog
      if product_backlog
        actual_time = calculate_time product_backlog.id, sprint_id, :actual_time
        product_backlog.update_attributes actual: actual_time
      end
    end
  end

  def update_remaining_time
    if self == task.log_works.last
      product_backlog = task.product_backlog
      if product_backlog
        remaining = calculate_time product_backlog.id, sprint_id, :remaining_time
        if product_backlog.update_attributes remaining: remaining
          master_sprint = self.task.log_works
            .find_by(remaining_time: self.remaining_time).master_sprint
          update_performance_of_burn_story master_sprint
        end
      end
    end
  end

  def update_estimate_of_task
    if self.task
      task.update_attributes estimate: task.estimate_time
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

  def update_performance_of_burn_story master_sprint
    item_burn_story = ItemPerformance.find_by performance_name:
      ItemPerformance.performance_names[:burn_story]
    total_burn_story = ProductBacklog.remaining_time_zero.count
    sprint.master_sprints.order(:day).each do |day|
      if day.day >= master_sprint.day
        if item_burn_story
          wpds = sprint.work_performances.performances_in_day(item_burn_story.id, day)
          update_or_create_wpd(item_burn_story, day, total_burn_story)
        end
      end
    end
  end

  def update_or_create_wpd item, day, total_burn_story
    if item
      wpds = sprint.work_performances.performances_in_day(item.id, day)
      if wpds.any?
        wpds.each do |wpd|
          wpd.update_attributes performance_value: total_burn_story
        end
      else
        task.work_performances.create sprint_id: sprint.id,
          item_performance_id: item.id,
          master_sprint_id: day.id,
          performance_value: total_burn_story
      end
    end
  end
end
