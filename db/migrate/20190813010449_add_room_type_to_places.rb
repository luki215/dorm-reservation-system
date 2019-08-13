class AddRoomTypeToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :room_type, :string
  end
end
