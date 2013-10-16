class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id, :secret, :token
  
  belongs_to :user
  
  validates :uid, :provider, :presence => true
  validates_uniqueness_of :uid, :scope => :provider
end
