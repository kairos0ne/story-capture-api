class CreateEpics < ActiveRecord::Migration[5.2]
  def change
    create_table :epics do |t|
      t.string :name
      t.text :summary
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
