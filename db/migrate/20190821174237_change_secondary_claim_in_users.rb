class ChangeSecondaryClaimInUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :primary_claim_id, unique: true, foreign_key: {to_table: :users}
    add_reference :users, :secondary_claim_id, unique: true, foreign_key: {to_table: :users}
  end
end
