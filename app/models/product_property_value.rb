class ProductPropertyValue < ActiveRecord::Base
  attr_accessible :product_id, :property_value_id
  
  belongs_to :product
  belongs_to :property_value
end
