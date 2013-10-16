class Collection < ActiveRecord::Base
  attr_accessible :customer_id, :name, :user_id, :description, :private
  
  has_many :cart_items
  belongs_to :user
  
  delegate :name, to: :user, prefix: true
  
  acts_as_likeable
  
  BROWSE_PER_PAGE = 30
  
  searchable auto_index: true, auto_remove: true, unless: :private do
    text :name_text, stored: true do
      name
    end
    text :description, stored: true
    text :owner_text, stored: true do
      user.name
    end
    text :artists_text, stored: true do
      cart_items.collect{|item | item.variant.product.artist.name }.to_sentence
    end
    text :artwork_names_text, stored: true do
      cart_items.collect{|item | item.variant.product.name }.to_sentence
    end
    
    string :name, stored: true
    
    string :owner, stored: true do
      user.name
    end
    
    string :artists, multiple: true, stored: true do
      cart_items.collect{|item | item.variant.product.artist.name }
    end
    
    string :artwork_names, multiple: true, stored: true do
      cart_items.collect{|item | item.variant.product.name }
    end
    
    time :created_at, stored: true
  end
  
  def self.filters(filters, page = 1)
    (search do      
      fulltext(filters[:search]) if filters[:search].present?

      paginate :page => page, :per_page => BROWSE_PER_PAGE
      order_by :created_at, :desc
    end)
  end
  
  def create_item(variant)
    cart_item = cart_items.new
    cart_item.variant = variant
    cart_item.user = user
    cart_item.item_type = ItemType.find_by_name 'collection'
    cart_item.save
  end
  
  def self.public_collections
    where(private: false)
  end
  
end
