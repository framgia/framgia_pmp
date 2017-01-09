class ProductBacklog < ActiveRecord::Base
  belongs_to :project
  belongs_to :sprint

  has_many :tasks
  has_many :work_performances
  has_many :log_works

  delegate :name, to: :project, prefix: true
  delegate :name, :id, to: :sprint, prefix: true, allow_nil: true

  scope :with_ids, ->ids{where id: ids}

  scope :remaining_time_zero, ->{where remaining: 0}

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

  private
  def total_estimation_time
    tasks = Task.includes(:log_works).of_product_backlog_and_sprint(id,
      sprint_id)
    tasks.map(&:actual_time).reduce(0, :+)
  end
end
