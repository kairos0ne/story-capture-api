class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string :task
      t.string :story_type
      t.integer :points
      t.references :epic, foreign_key: true

      t.timestamps
    end
  end
end
