class CreateAliances < ActiveRecord::Migration[5.2]
  def change
    create_table :aliances do |t|
      t.string :name
      t.references :founder, foreign_key: true, foreign_key: {to_table: :users}
      t.text :note

      t.timestamps
    end
    add_reference :users, :aliance, index: true
  end
end
