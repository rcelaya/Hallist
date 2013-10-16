class Brand < ActiveRecord::Base

  has_many :variants
  has_many :products
  has_one :artist, class_name: 'User'

  validates :name,  :presence => true,       :length => { :maximum => 255 }, :uniqueness => true
                    #:format   => { :with => CustomValidators::Names.name_validator }
end
