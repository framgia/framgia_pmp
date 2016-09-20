class RemoveDescriptionFromWorkPerformance < ActiveRecord::Migration
  def change
    remove_column :work_performances, :description, :string
  end
end
