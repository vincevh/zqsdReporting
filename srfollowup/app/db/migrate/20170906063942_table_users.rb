class TableUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users
    add_column :users, :username, :string
    add_column :users, :battletag, :string
  end
end
