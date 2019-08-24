class ApollogizeMailWorker
  include Sidekiq::Worker

  def perform(user_id)
    UserMailer.apollogize_mail(user_id).deliver_now unless User.find(user_id).apollogize_mail_sent
  end
end
