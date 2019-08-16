class AddDormToAppSetting < ActiveRecord::Migration[5.2]
  def change
    add_column :app_settings, :dorm, :integer
  end
end
