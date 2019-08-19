require "securerandom"

class SendWelcomeMailsWorker
  include Sidekiq::Worker

  def perform(*args)
    User.where(welcome_mail_sent: false, admin: false).each_with_index do |user, j|
      SendWelcomeMailWorker.perform_in( ((j / 100)*5).minutes, user.id)
    end
  end
end
