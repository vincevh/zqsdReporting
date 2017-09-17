class CreateSrs < ActiveRecord::Migration[5.1]
  def change
    create_table :srs do |t|
      t.integer :userid
      t.datetime :datetime
      t.string :winloss
      t.integer :newsr
      t.string :performance
      t.integer :srvariation
      t.string :hero
      t.text :comment

      t.timestamps
    end
  end
end
