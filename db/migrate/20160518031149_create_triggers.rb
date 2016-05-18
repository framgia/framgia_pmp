class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.references :sheet, index: true, foreign_key: true
      t.string :trigger
      t.string :source

      t.timestamps null: false
    end
  end
end
