class AddItemPhaseToWorkPerformance < ActiveRecord::Migration
  def change
    add_column :work_performances, :user_id, :integer
    add_reference :work_performances, :phase_item, index: true, foreign_key: true
  end
end
