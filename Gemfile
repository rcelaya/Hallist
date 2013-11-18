source 'http://rubygems.org'

ruby "1.9.3"

## Bundle rails:
gem 'rails', '3.2.8'
gem 'fog' , '1.6.0' 
gem 'compass_twitter_bootstrap','2.0.3'
gem 'compass-rails' , '1.0.3'
gem 'sass-rails',   '~> 3.2.3'
gem 'tinymce-rails','3.5.6'
gem "socialization", '0.4.0'

gem 'authlogic'
gem 'omniauth', '1.1.1'
gem 'omniauth-twitter', '~> 0.0.16'
gem 'omniauth-facebook','1.4.0'
gem 'carmen-rails', '~> 1.0.0.beta3'
gem "draper", '0.18.0'
gem 'sunspot_rails'
gem 'sunspot_solr'
gem "rails-backbone", '0.8.0'
gem 'merit', '1.0.1'
gem 'detect_browser_os', '0.2.0'

gem 'twitter' , '4.2.0'
gem 'koala', '1.5.0'
gem 'sidekiq', '2.5.3'
gem 'open-meta-tags', :require => 'open_meta_tags'
gem 'coffee-rails', '~> 3.2.1'
gem 'progress_bar'
gem 'rails_12factor'

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
  
gem 'braintree' , '2.18.0'
gem 'activemerchant', :require => 'active_merchant'
gem 'bluecloth',     '~> 2.1.0'
gem 'cancan', '~> 1.6.7'
gem 'haml-rails', '0.3.5'
#gem 'dalli', '~> 1.0.2'

gem "friendly_id", "~> 3.3"
gem "jquery-rails", '2.1.3'
gem "rails_config", '0.3.1'
gem 'airbrake', '3.1.4'
gem 'newrelic_rpm'

#gem 'memcache-client', '~> 1.8.5'
group :production do
  gem 'unicorn'
  gem 'pg'
end

gem 'nested_set', '~> 1.7.0'
gem 'nokogiri', '~> 1.5.0'
gem 'paperclip', '3.3.0'
gem 'prawn', '~> 0.12.0'
gem "rails3-generators", :git => "https://github.com/neocoin/rails3-generators.git"
gem 'rmagick',    :require => 'RMagick'
gem 'rake', '~> 0.9.2'
gem 'state_machine', '~> 1.1.2'
gem 'will_paginate', '~> 3.0.0'
gem 'dynamic_form', '1.1.4'

gem 'ffaker', '1.15.0'

gem 'conekta', :git => 'git://github.com/conekta/conekta-ruby.git'

group :development do
  gem 'sqlite3'
  gem "autotest-rails-pure" , '4.1.2'
  gem "rails-erd", '1.0.0'
  gem "debugger" 
  gem "awesome_print", '1.1.0'
  gem 'capistrano', '2.13.5'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'thin'
  gem 'pg'
end

group :test, :development do
  gem "rspec-rails"
  gem 'capybara', "~> 1.1"#, :git => 'git://github.com/jnicklas/capybara.git'
  gem 'launchy', '2.1.2'
  gem 'database_cleaner', '0.9.1'
end
