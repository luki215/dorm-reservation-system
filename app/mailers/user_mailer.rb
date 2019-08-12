class UserMailer < ApplicationMailer
 
  def welcome_email(email,pw)
    @password=pw
    mail(to: email, subject: 'Zámluvový systém / Reservation system')
  end
end
