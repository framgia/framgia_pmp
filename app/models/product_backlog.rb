class ProductBacklog < ActiveRecord::Base
  belongs_to :project
  belongs_to :sprint

  has_many :activities

  delegate :name, to: :project, prefix: true
  delegate :name, :id, to: :sprint, prefix: true, allow_nil: true

  def calculate_remaining_time
     tmp_remaining = 0
     if sprint.present?
       sprint.activities.where("product_backlog_id = ?", id).each do |activity|
         tmp_remaining += activity.log_works.last.remaining_time
       end
       self.remaining = tmp_remaining
       save!
     end
     self.remaining
  end
end
