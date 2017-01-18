class ProductBacklog < ActiveRecord::Base
  belongs_to :project
  belongs_to :sprint

  has_many :tasks

  delegate :name, to: :project, prefix: true
  delegate :name, :id, to: :sprint, prefix: true, allow_nil: true

  scope :with_ids, ->ids{where id: ids}

  def total_remaining_time
    if self.tasks.any?
      tasks = Task.includes(:log_works).of_product_backlog_and_sprint(id,
        sprint_id)
      remaining = tasks.map(&:remaining_time).reduce(0, :+)

      self.update_attributes remaining: remaining
      remaining
    end
  end

  def calculate_actual_time
    if self.tasks.any?
      actual_time = total_estimation_time
      self.update_attributes actual: actual_time
      actual_time
    end
  end

  def calculate_estimate_time_of_story
    if self.tasks.any?
      estimate_time = total_estimate_time_of_story
      self.update_attributes estimate: estimate_time
      estimate_time
    end
  end

  private
  def total_estimation_time
    tasks = Task.includes(:log_works).of_product_backlog_and_sprint(id,
      sprint_id)
    tasks.map(&:actual_time).reduce(0, :+)
  end

  def total_estimate_time_of_story
    tasks = Task.includes(:log_works).of_product_backlog_and_sprint(id, sprint_id)
    tasks.map(&:estimate).compact.reduce(0, :+)
  end
end
