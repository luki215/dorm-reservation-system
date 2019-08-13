class RemoveFieldNameFromTableName < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :allow_alliance, :boolean
  end
end
