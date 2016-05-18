class AddStartDateToSprint < ActiveRecord::Migration
  def change
    add_column :sprints, :start_date, :date
  end
end
