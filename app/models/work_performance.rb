class WorkPerformance < ActiveRecord::Base
  belongs_to :phase_item
  belongs_to :activity
  belongs_to :sprint
  belongs_to :master_sprint

  ATTRIBUTES_PARAMS = [:description, :plan, :actual, :spent_hour,
    :burned_hour, :estimated_story, :burned_story, :estimated_task]

  scope :total_each_phaseitem_a_day_of_team, ->(day, team) do
    where(master_sprint_id: day.id, user_id: team)
  end
  scope :data_of_an_item_in_a_day, ->(day, phase_item_id, users_in_team) do
    where(master_sprint_id: day.id,
      phase_item_id: phase_item_id, user_id: users_in_team)
  end
end
