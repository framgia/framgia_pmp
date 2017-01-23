class RemoveEndDateFromProject < ActiveRecord::Migration
  def change
    remove_column :projects, :end_date, :date
  end
end
