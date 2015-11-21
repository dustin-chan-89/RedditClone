class AddSessionToken < ActiveRecord::Migration
  def change
    add_column :users, :session_token, :string, null: false, default: "placeholder"
    add_index :users, :session_token, unique: true
  end
end
