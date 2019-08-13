class RemoveRoomSwitchShareInfoNameFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :allow_room_switch, :boolean
    remove_column :users, :allow_share_info, :boolean
    remove_column :users, :move_with_alliance, :boolean
  end
end
