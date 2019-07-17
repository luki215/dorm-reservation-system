class CreateAllianceMembershipRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :alliance_membership_requests do |t|
      t.references :user, foreign_key: true
      t.references :aliance, foreign_key: true

      t.timestamps
    end
  end
end
