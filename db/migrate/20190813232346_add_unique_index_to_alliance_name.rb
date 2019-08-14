class AddUniqueIndexToAllianceName < ActiveRecord::Migration[5.2]
  def change
    change_column :aliances, :name, :string, null: false
    add_index :aliances, :name, unique: true
  end
end
