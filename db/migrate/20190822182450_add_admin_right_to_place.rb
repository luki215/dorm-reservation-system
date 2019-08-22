class AddAdminRightToPlace < ActiveRecord::Migration[5.2]
  def change
    add_reference :places, :admin_claim, foreign_key: {to_table: :users}
  end
end
