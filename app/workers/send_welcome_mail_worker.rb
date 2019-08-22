require "securerandom"

class SendWelcomeMailWorker
  include Sidekiq::Worker

  def perform(userId)
    passwd = SecureRandom.hex 8
    @user = User.find(userId)
    @user.password = passwd
    @user.save!
    UserMailer.welcome_email(userId,passwd).deliver_later
  end
end
