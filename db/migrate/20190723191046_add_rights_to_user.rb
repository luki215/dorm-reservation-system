class AddRightsToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :places, :primary_claim, foreign_key: {to_table: :users}
    add_reference :places, :secondary_claim, foreign_key: {to_table: :users}
  end
end
