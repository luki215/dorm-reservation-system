class UniqueUserOnPlaces < ActiveRecord::Migration[5.2]
  def change
    remove_index :places, :user_id
    add_index :places, :user_id, unique: true
  end
end
