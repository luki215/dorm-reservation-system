class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :building
      t.string :floor
      t.string :cell
      t.string :room
      t.string :bed
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :places, :building
    add_index :places, :floor
    add_index :places, :cell
    add_index :places, :room
    add_index :places, :bed
  end
end
