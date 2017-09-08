class TableSr < ActiveRecord::Migration[5.0]
  def change
    create_table :srs
    add_column :srs, :userid, :integer
    add_column :srs, :datetime, :datetime
    add_column :srs, :winloss, :string
    add_column :srs, :newsr, :integer
    add_column :srs, :performance, :string
    add_column :srs, :srvariation, :integer
    add_column :srs, :hero, :string
    add_column :srs, :comment, :text
  end
end
