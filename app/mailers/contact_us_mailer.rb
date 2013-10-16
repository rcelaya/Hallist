class ContactUsMailer < ActionMailer::Base

  default to: 'info@hallist.com',
          from: 'Hallist bot <bot@hallist.com>'

  def new_inquiry(email, name, message)
    @email = email
    @name = name
    @message = message

    mail title: "New inquiry from user"
  end
end
