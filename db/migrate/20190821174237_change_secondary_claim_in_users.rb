class ChangeSecondaryClaimInUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :places, :primary_claim_id
    add_index :places, :primary_claim_id, unique: true
    remove_index :places, :secondary_claim_id
    add_index :places, :secondary_claim_id, unique: true
  end
end
