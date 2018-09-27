class CreateSubtasks < ActiveRecord::Migration[5.2]
  def change
    create_table :subtasks do |t|
      t.string :task
      t.string :task_type
      t.integer :points
      t.references :story, foreign_key: true

      t.timestamps
    end
  end
end
