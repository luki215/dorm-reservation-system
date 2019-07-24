class CreateAppSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :app_settings do |t|
      t.datetime :first_round_start
      t.datetime :second_round_start
      t.datetime :third_round_start
      t.datetime :fourth_round_start
      t.boolean :is_running

      t.timestamps
    end
  end
end
