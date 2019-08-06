class CreateSwitchRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :switch_rooms do |t|
      t.references :user_requesting, foreign_key: {to_table: :users}
      t.references :user_requested, foreign_key: {to_table: :users}
      t.text :note
      t.timestamps
    end
  end
end
