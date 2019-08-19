class AddWelcomeMailSentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :welcome_mail_sent, :boolean, default: false
  end
end
