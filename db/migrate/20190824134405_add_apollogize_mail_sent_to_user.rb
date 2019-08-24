class AddApollogizeMailSentToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :apollogize_mail_sent, :boolean, default: false
    add_index :users, :apollogize_mail_sent
  end
end
