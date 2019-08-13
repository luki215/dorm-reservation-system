class AddRoomTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :room_type, :string
  end
end
