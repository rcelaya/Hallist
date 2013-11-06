 Hadean::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # config.force_ssl = true

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # config.assets.precompile += %w( *.css *.js )

  config.assets.precompile += %w( *.js )
  config.assets.precompile += [ 'admin.css',
                                'autocomplete.css',
                                'chosen.css',
                                'generic_dialog.css',
                                'home_page.css',
                                'ie.css',
                                'ie6.css',
                                'login.css',
                                'main.css',
                                'markdown.css',
                                'outfits.css',
                                'print.css',
                                'product_page.css',
                                'products_page.css',
                                'screen.css',
                                'shopping_cart_page.css',
                                'signup.css',
                                'sprite.css',
                                'store_credits.css',
                                'stylist_admin.css',
                                'stylist_cart.css',
                                'tables.css',
                                'cupertino/jquery-ui-1.8.12.custom.css',
                                'modstyles.css',
                                'scaffold.css',
                                'admin/foundation.css',
                                'admin/app.css',
                                'admin/ie.css', 'markitup/skins/markitup/style.css','markitup/sets/default/style','colorpicker.css']

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files
  config.cache_store = :memory_store
  #config.cache_store = :dalli_store

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"
  
  ActionMailer::Base.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => 'hallist.parbros.com' }
  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify


  config.after_initialize do
    ActionMailer::Base.smtp_settings = {
      :address        => Settings.email.server,
      :port           => Settings.email.port,
      :authentication => :plain,
      :user_name      => Settings.email.username,
      :password       => Settings.email.password,
      :domain         => 'magnolias.parbros.com'  
    }
    #Formtastic::SemanticFormBuilder.send(:include, Formtastic::DatePicker)
    #Formtastic::SemanticFormBuilder.send(:include, Formtastic::FuturePicker)
    #Formtastic::SemanticFormBuilder.send(:include, Formtastic::YearPicker)

    ActiveMerchant::Billing::Base.mode = :production
    #::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
    #  :login      => Settings.paypal.login
    #  :password   => Settings.paypal.password
    #  :signature  => Settings.paypal.signature
    #)

    # ::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
    #   :login    => HADEAN_CONFIG['authnet']['login'],
    #   :password => HADEAN_CONFIG['authnet']['password'],
    #   :test     => true
    # )

    # ::CIM_GATEWAY = ActiveMerchant::Billing::AuthorizeNetCimGateway.new(
    #   :login    => HADEAN_CONFIG['authnet']['login'],
    #   :password => HADEAN_CONFIG['authnet']['password'],
    #   :test     => true
    # )

    # ::GATEWAY = ActiveMerchant::Billing::BraintreeGateway.new(
    #   :merchant_id => Settings.braintree.merchant_id,
    #   :public_key  => Settings.braintree.public_key,
    #   :private_key => Settings.braintree.private_key,
    #   :test => true
    # )
    
    ::GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(
     :login      => Settings.paypal.login,
     :password   => Settings.paypal.password,
     :signature  => Settings.paypal.signature
    )
  end
end
