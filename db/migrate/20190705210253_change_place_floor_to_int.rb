class ChangePlaceFloorToInt < ActiveRecord::Migration[5.2]
  def change
    change_column :places, :floor, 'integer USING CAST(floor AS integer)'
  end
end
