##  THESE SETTING SHOULD NOT NEED TO BE SECURE.  IF YOU NEED TO USE SECURE
##  SETTINGS USE -- config/config.yml AND FOLLOW THE INSTRUCTIONS ON THAT PAGE
##  TO DEPLOY

require 'yaml'

SETTINGS = {
  :admin_grid_rows  => 25,
  :use_foreign_keys => false
}

# Loading variables for Omniauth providers

env = YAML.load_file("#{Rails.root}/config/settings.yml")['omniauth'][Rails.env]

FACEBOOK_KEY = ENV['FACEBOOK_KEY'] || env['facebook']['key']
FACEBOOK_SECRET = ENV['FACEBOOK_SECRET'] || env['facebook']['secret']

TWITTER_KEY = ENV['TWITTER_KEY'] || env['twitter']['key']
TWITTER_SECRET = ENV['TWITTER_SECRET'] || env['twitter']['secret']

#APP_CONFIG = YAML.load_file(File.join(Rails.root, "config", "config.yml"))[Rails.env]

=begin
### These options are stored in each of the environment files

#Paperclip.options[:image_magick_path] = '/opt/local/bin'
if RAILS_ENV == "development"

  Paperclip.options[:command_path] = "DYLD_LIBRARY_PATH='/Users/davidhenner/ImageMagick-6.6.3/lib' /Users/davidhenner/ImageMagick-6.6.3/bin"

  #Paperclip.options[:command_path] = '/Users/davidhenner/ImageMagick-6.6.3/bin'
  #Paperclip.options[:command_path] = '/usr/local/bin'
  ###  UNCOMMENT IF USING MACPORTS
  #Paperclip.options[:command_path] = '/opt/local/bin'
else
  Paperclip.options[:command_path] = '/usr/bin'
end
=end

