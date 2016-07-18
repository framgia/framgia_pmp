class WorkPerformance < ActiveRecord::Base
  belongs_to :phase
  belongs_to :activity

  ATTRIBUTES_PARAMS = [:description, :plan, :actual, :spent_hour,
    :burned_hour, :estimated_story, :burned_story, :estimated_task]
end
