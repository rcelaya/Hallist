class Notice < ActiveRecord::Base
  attr_accessible :active, :content, :background_color, :color, :image
  
  has_attached_file :image, {
    :styles => {  :small => '460x',
                  :large => '700x'},
    :default_style => :small,
    :storage => :fog,
    :fog_credentials => {
          :aws_access_key_id     => Settings.amazon_s3.access_key_id,
          :aws_secret_access_key => Settings.amazon_s3.secret_key,
          :provider              => 'AWS'},
    :path => ":attachment/:style/:id-:basename.:extension",
    :fog_directory => Settings.amazon_s3.bucket,
    :fog_public => true
  }
  
  scope :active, where(active: true)
end
