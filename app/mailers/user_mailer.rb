class UserMailer < ActionMailer::Base
  default from: "arturo@arto.mx"

  def welcome_mail(user)
  	@user = user
  end
end
