class ContactUsMailer < ActionMailer::Base

  default to: 'HALLIST <info@hallist.com>',
          from: 'HALLIST SUPPORT <bot@hallist.com>'

  def new_inquiry(email, name, message)
    @email = email
    @name = name
    @message = message

    mail title: "New inquiry from user"
  end
end
