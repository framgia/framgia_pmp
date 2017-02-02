class AddPhaseNameToProjectPhase < ActiveRecord::Migration
  def change
    add_column :project_phases, :phase_name, :string
  end
end
