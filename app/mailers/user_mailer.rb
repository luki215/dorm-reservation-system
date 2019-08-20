class UserMailer < ApplicationMailer
  default :from => "Zámluvy <noreply@#{ENV['HOST']}>"
  def welcome_email(usr_id,pw)
    @password=pw
    user = User.find(usr_id)
    mail(to: user.email, subject: 'Zámluvový systém / Reservation system')
    user.welcome_mail_sent = true
    user.save!
  end
end
