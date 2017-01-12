module UpdatePerformance
  extend ActiveSupport::Concern

  def update_performance_of_spent_time
    item_spent_time = ItemPerformance.find_by performance_name: :spent_time
    if item_spent_time
      wpd = sprint.work_performances.of_task_in_day(self.task_id,
        self.master_sprint_id, item_spent_time.id)
      spent_time = get_previous_logwork.remaining_time - self.remaining_time
      if wpd.any?
        wpd.first.update_attributes performance_value: spent_time
      else
        task.work_performances.create sprint_id: self.sprint.id,
          item_performance_id: item_spent_time.id,
          master_sprint_id: self.master_sprint.id,
          performance_value: spent_time
      end
    end
  end

  def update_performance_of_burn_story
    item_burn_story = ItemPerformance.find_by performance_name: :burn_story
    if item_burn_story
      wpds = sprint.work_performances.performances_in_day(self.master_sprint_id,
        item_burn_story.id)
      total_burn_story = ProductBacklog.remaining_time_zero.count
      if wpds.any?
        wpds.each do |wpd|
          wpd.update_attributes performance_value: total_burn_story
        end
      else
        wpds.create sprint_id: self.sprint.id,
          item_performance_id: item_burn_story.id,
          master_sprint_id: self.master_sprint.id,
          performance_value: total_burn_story
      end
    end
  end

  def get_previous_logwork
    if self.master_sprint.day > 1
      prev_day = sprint.master_sprints.find_by day: self.master_sprint.day - 1
      log_work = task.log_works.find_by master_sprint_id: prev_day.id
    else
      log_work = self
    end
  end
end
