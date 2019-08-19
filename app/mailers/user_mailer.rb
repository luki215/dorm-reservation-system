class UserMailer < ApplicationMailer
 
  def welcome_email(usr_id,pw)
    @password=pw
    user = User.find(usr_id)
    mail(to: user.email, subject: 'Zámluvový systém / Reservation system')
    user.welcome_mail_sent = true
    user.save!
  end
end
