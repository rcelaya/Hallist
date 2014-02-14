class Notifier < ActionMailer::Base
  default :from => "HALLIST <support@hallist.com>"

  # Simple Welcome mailer
  # => CUSTOMIZE FOR YOUR OWN APP
  #
  # @param [user] user that signed up
  # => user must respond to email_address_with_name and name
  def signup_notification(recipient)
    @account = recipient

    #attachments['LogoMailingHallist_head.png'] = File.read("#{Rails.root}/assets/images/LogoMailingHallist_head.png")
    #attachments['terms.pdf'] = {:content => generate_your_pdf_here() }

    mail(:to => recipient.email_address_with_name,
         :subject => "New account information") #do |format|
      #format.text { render :text => "Welcome!  #{recipient.name} go to #{customer_activation_url(:a => recipient.perishable_token )}" }
      #format.html { render :text => "<h1>Welcome to HALLIST!</h1> <p>Your account has been created for the following email address: <br> #{recipient.email}</p> <p>Please finish your registration process here: <a href='#{customer_activation_url(:a => recipient.perishable_token )}'>Click to Activate</a></p>  <p>Sincerely, <br> The HALLIST team</p>" }
    #end

  end

  def password_reset_instructions(user)
    @user = user
    @url  = edit_customer_password_reset_url(:id => user.perishable_token)
    mail(:to => user.email,
         :subject => "Reset Password Instructions")
  end


  def order_confirmation(order, print_oxxo, reference_id, item_description, total, currency)
    @order  = order
    @user   = order.user
    @print_oxxo = print_oxxo
    @reference_id = reference_id
    @item_description = item_description
    @total = total
    @currency = currency
    mail(:to => order.email,
         :subject => "Order Confirmation")
  end

  def order_complete(order, reference_id, item_description, total, currency)
    @order  = order
    @user   = order.user
    @reference_id = reference_id
    @item_description = item_description
    @total = total
    @currency = currency

    mail(:to => order.email,
         :cc => "HALLIST <info@hallist.com>",
         :subject => 'Purchase Complete!')

  end

end
