class CreateAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :auths do |t|
      t.string :client_id
      t.string :client_secret
      t.string :redirect_uri
      t.string :auth_token

      t.timestamps
    end
  end
end
