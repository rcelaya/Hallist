class Notifier < ActionMailer::Base
  default :from => "HALLIST <info@hallist.com>"

  # Simple Welcome mailer
  # => CUSTOMIZE FOR YOUR OWN APP
  #
  # @param [user] user that signed up
  # => user must respond to email_address_with_name and name
  def signup_notification(recipient)
    puts recipient.to_yaml
    @account = recipient

    #attachments['an-image.jp'] = File.read("an-image.jpg")
    #attachments['terms.pdf'] = {:content => generate_your_pdf_here() }

    mail(:to => recipient.email_address_with_name,
         :subject => "New account information") do |format|
      format.text { render :text => "Welcome!  #{recipient.name} go to #{customer_activation_url(:a => recipient.perishable_token )}" }
      format.html { render :text => "<h1>Welcome to HALLIST!</h1> <p>Your account has been created for the following email address: <br> #{recipient.email}</p> <p>Please finish your registration process here: <a href='#{customer_activation_url(:a => recipient.perishable_token )}'>Click to Activate</a></p>  <p>Sincerely, <br> The HALLIST team</p>" }
    end

  end

  def password_reset_instructions(user)
    @user = user
    @url  = edit_customer_password_reset_url(:id => user.perishable_token)
    mail(:to => user.email,
         :subject => "Reset Password Instructions")
  end


  def order_confirmation(order,invoice)
    @invoice = invoice
    @order  = order
    @user   = order.user
    @url    = root_url
    @site_name = 'HALLIST'
    mail(:to => order.email,
         :subject => "Order Confirmation")
  end

end
