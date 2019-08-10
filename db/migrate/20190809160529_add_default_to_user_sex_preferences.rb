class AddDefaultToUserSexPreferences < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :same_sex_room, :boolean, default: true
    change_column :users, :same_sex_cell, :boolean, default: false
  end
end
