class RemovePhaseAssigneeFromWorkPerformance < ActiveRecord::Migration
  def change
    remove_reference :work_performances, :assignee, index: true, foreign_key: true
    remove_reference :work_performances, :phase, index: true, foreign: true
    remove_reference :work_performances, :item_performance, index: true, foreign_key: true
  end
end
