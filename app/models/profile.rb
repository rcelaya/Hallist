class Profile < ActiveRecord::Base
  #
  # Accessor
  #
  attr_accessible :about, :avatar, :birth_date, :username, :user_id, :settings,
                  :website, :facebook, :twitter, :pinterest, :instagram, :city
  
  #
  # Associations
  #
  belongs_to :user
  
  #
  # Attachment
  #
  has_attached_file :avatar, {
    :styles => {  :mini => '25x25',
                  :small => '100x100',
                  :profile => '180x180'},
    :default_style => :profile,
    :storage => :fog,
    :fog_credentials => {
          :aws_access_key_id     => Settings.amazon_s3.access_key_id,
          :aws_secret_access_key => Settings.amazon_s3.secret_key,
          :provider              => 'AWS'},
    :path => ":attachment/:style/:id-:basename.:extension",
    :fog_directory => Settings.amazon_s3.bucket,
    :fog_public => true
  }
  
  #
  # Serialize
  #
  serialize :settings
  
  #
  # Callback
  #
  after_create :initialize_settings
  
  def featured_avatar(size = :mini)
    avatar.present? ? avatar.url(size) : "/assets/avatarphoto.png"
  end
  
  def initialize_settings
    self.settings = {
      twitter_share: false,
      facebook_share: false
    }
    self.save
  end
end
