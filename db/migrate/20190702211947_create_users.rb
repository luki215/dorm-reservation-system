class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :fullname
      t.boolean :allow_alliance
      t.boolean :allow_room_switch
      t.boolean :move_with_alliance
      t.boolean :male
      t.boolean :same_sex_room
      t.boolean :same_sex_cell
      t.boolean :allow_share_info
      t.text :note

      t.timestamps
    end
  end
end
