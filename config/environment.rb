# Load the rails application
require File.expand_path('../application', __FILE__)
require File.expand_path('../../lib/printing/invoice_printer', __FILE__)

Paperclip.options[:command_path] = "/usr/local/bin"

# Initialize the rails application
Hadean::Application.initialize!
Hadean::Application.configure do 

  # Config smtp setting for sendgrid
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['app16290187@heroku.com'],
    :password       => ENV['Passw0rd'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }


  config.after_initialize do
    unless Settings.encryption_key
      raise "
      ############################################################################################
      !  You need to setup the settings.yml
      !  copy settings.yml.example to settings.yml
      !
      !  Make sure you personalize the passwords in this file and for security never check this file in.
      ############################################################################################
      "
    end
  end
end
