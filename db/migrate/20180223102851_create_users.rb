class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :token
      t.string :jira_token
      t.string :email
      t.boolean :admin, :default => false 
      t.boolean :member, :default => true
      t.string :password_digest

      t.timestamps
    end
  end
end
