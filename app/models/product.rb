# == Schema Information
#
# Table name: products
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)     not null
#  description          :text
#  product_keywords     :text
#  tax_category_id      :integer(4)
#  product_type_id      :integer(4)      not null
#  prototype_id         :integer(4)
#  shipping_category_id :integer(4)      not null
#  tax_category_id        :integer(4)      not null
#  permalink            :string(255)     not null
#  available_at         :datetime
#  deleted_at           :datetime
#  meta_keywords        :string(255)
#  meta_description     :string(255)
#  featured             :boolean(1)      default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#  description_markup   :text
#  active               :boolean(1)      default(FALSE)
#  brand_id             :integer(4)
#

class Product < ActiveRecord::Base
  has_friendly_id :permalink, :use_slug => false

  serialize :product_keywords, Array

  attr_accessor :available_shipping_rates # these the the shipping rates per the shipping address on the order

  belongs_to :brand
  belongs_to :product_type
  belongs_to :prototype
  belongs_to :shipping_category
  belongs_to :tax_category #tax_status

  has_many :product_properties
  has_many :properties,          :through => :product_properties

  has_many :variants
  has_many :images, :as         => :imageable,
                    :order      => :position,
                    :dependent  => :destroy

  has_one :master_variant,
    :class_name => 'Variant',
    :conditions => ["variants.master = ? AND variants.deleted_at IS NULL", true]

  has_many :active_variants,
    :class_name => 'Variant',
    :conditions => ["variants.deleted_at IS NULL", true]

  has_many :inactive_master_variants,
    :class_name => 'Variant',
    :conditions => ["variants.deleted_at IS NOT NULL AND variants.master = ? ", true]

  has_many   :comments, :as => :commentable
  
  has_many :product_property_values
  has_many :property_values, :through => :product_property_values
  
  has_one :address, as: :addressable
  has_many :likes, as: :likeable
  
  has_one :auction

  before_validation :sanitize_data
  before_save :create_content

  accepts_nested_attributes_for :variants, :reject_if => proc { |attributes| attributes['sku'].blank? }, :allow_destroy => true
  
  accepts_nested_attributes_for :product_properties, :reject_if => proc { |attributes| attributes['description'].blank? }, :allow_destroy => true

  accepts_nested_attributes_for :images, :reject_if => lambda { |t| (t['photo'].nil? && t['photo_from_link'].blank?) }, :allow_destroy => true
  
  accepts_nested_attributes_for :address, :auction

  validates :shipping_category_id,  :presence => true
  validates :tax_category_id,         :presence => true
  validates :product_type_id,       :presence => true
  #validates :prototype_id,          :presence => true
  validates :permalink, :uniqueness => true, :length => { :maximum => 150 }
  validates :name,                  :presence => true, :length => { :maximum => 165 }
  validates :description_markup,    :presence => true, :length => { :maximum => 2255 },     :if => :active
  validates :meta_keywords,         :presence => true,       :length => { :maximum => 255 }, :if => :active
  validates :meta_description,      :presence => true,       :length => { :maximum => 255 }, :if => :active

  acts_as_likeable

  #
  # Constants
  #
  BROWSE_PER_PAGE = 30

  searchable auto_index: true, auto_remove: true, if: :active do
    string  :name, stored: true
    string :product_keywords, multiple: true, stored: true do
      product_keywords.split(',')
    end

    text :description,   stored: true
    text :name, stored: true
    text :artist_name, stored: true do
      brand.name
    end

    double :price, stored: true do
      price_range.last
    end
    
    integer :property_values_id, :multiple => true, stored: true do
      property_values.map(&:id)
    end
    
    integer :product_type_ids, :multiple => true, stored: true do
      product_type = ProductType.find_by_id(product_type_id)
      product_type.self_and_descendants.map &:id
    end
    
    time :created_at
  end

  def self.standard_search(args, params)
    (search(:include => [:properties, :images]) do
      keywords(args)
      any_of do
        with(:deleted_at).greater_than(Time.zone.now)
        with(:deleted_at, nil)
      end
      paginate :page => params[:page].to_i, :per_page => params[:rows].to_i#params[:page], :per_page => params[:rows]
      
    end)
  end
  
  def self.filters(filters, page = 1)
    (search(include: [variants: [:variant_properties], brand: [artist: [:profile]]]) do
      with(:property_values_id).any_of([filters[:property_values_id]].flatten) if filters[:property_values_id]
      with(:product_type_ids).any_of([filters[:product_type_id]].flatten) if filters[:product_type_id]
      
      fulltext(filters[:search]) if filters[:search].present?
      
      if filters[:price].present?
        with(:price).greater_than(filters[:price][:from]) if filters[:price][:from].present?
        with(:price).less_than(filters[:price][:to]) if filters[:price][:to].present?
      end

      paginate :page => page, :per_page => BROWSE_PER_PAGE
      order_by :created_at, :desc
    end)
  end
  
  def artist
    UserDecorator.decorate(brand.artist)
  end

  # gives you the tax rate for the give state_id and the time.
  #  Tax rates can change from year to year so Time is a factor
  #
  # @param [Integer] state.id
  # @param [Optional Time] Time now if no value is passed in
  # @return [TaxRate] TaxRate for the state at a given time
  def tax_rate(state_id, time = Time.zone.now)
    self.tax_category.tax_rates.first
    # self.tax_category.tax_rates.where(["state_id = ? AND
    #                        start_date <= ? AND
    #                        (end_date > ? OR end_date IS NULL) AND
    #                        active = ?", state_id,
    #                                     time.to_date.to_s(:db),
    #                                     time.to_date.to_s(:db),
    #                                     true]).order('start_date DESC').first
  end  

  # in the admin form this is the method called when the form is submitted, The method sets
  # the product_keywords attribute to an array of these values
  #
  # @param [String] value for set_keywords in a products form
  # @return [none]
  def set_keywords=(value)
    self.product_keywords = value ? value.split(',').map{|w| w.strip} : []
  end

  # method used by forms to set the array of keywords separated by a comma
  #
  # @param [none]
  # @return [String] product_keywords separated by comma
  def set_keywords
    product_keywords ? product_keywords.join(', ') : ''
  end

  # range of the product prices in plain english
  #
  # @param [Optional String] separator between the low and high price
  # @return [String] Low price + separator + High price
  def display_price_range(j = ' to ')
    price_range.join(j)
  end

  # range of the product prices (Just teh low and high price) as an array
  #
  # @param [none]
  # @return [Array] [Low price, High price]
  def price_range
    return @price_range if @price_range
    return @price_range = ['N/A', 'N/A'] if active_variants.empty?
    @price_range = active_variants.inject([active_variants.first.price, active_variants.first.price]) do |a, variant|
      a[0] = variant.price if variant.price < a[0]
      a[1] = variant.price if variant.price > a[1]
      a
    end
  end

  # Answers if the product has a price range or just one price.
  #   if there is more than one price returns true
  #
  # @param [none]
  # @return [Boolean] true == there is more than one price
  def price_range?
    !(price_range.first == price_range.last)
  end

  # find the last master variant that was inactivated
  #
  # @param [none]
  # @return [Variant or nil] variant of the last master variant that was inactivated
  def last_master_variant
    inactive_master_variants.try(:last)
  end
  
  def self.most_recents
    self.active.order('created_at DESC').limit(12)
  end


  # Solr searching for products
  #
  # @param [args]
  # @param [params]  :rows, :page
  # @return [ Product ]
  def self.standard_search(args, params)
      Product.includes( [:properties, :images]).
              where(['products.name LIKE ? OR products.meta_keywords LIKE ?', "%#{args}%", "%#{args}%"]).
              where(['products.deleted_at IS NULL OR products.deleted_at > ?', Time.zone.now]).
              paginate :page => params[:page].to_i, :per_page => params[:rows].to_i
  end

  # This returns the first featured product in the database,
  # if there isn't a featured product the first product will be returned
  #
  # @param [none]
  # @return [ Product ]
  def self.featured
    product = where({ :products => {:featured => true} } ).includes(:images)
    product ? product : includes(:images).where(['products.deleted_at IS NULL'])
  end

  def self.active
    where({ :products => {:active => true} } )
  end
  
  def self.browse(page = 1)
    self.active.includes(:variants).page(page).per_page(BROWSE_PER_PAGE)
  end
  
  def self.by_product_type(product_type_id)
    product_type = ProductType.find_by_id(product_type_id)
    product_types = product_type ? product_type.self_and_descendants.collect{|p| p.id} : nil
    self.where('product_type_id IN (?)', product_types || featured_product_types)
  end

  def available?
    active && (!deleted_at || deleted_at < Time.zone.now)
  end

  # returns the brand's name or a blank string
  #  ex: obj.brand_name => 'Nike'
  #
  # @param [none]
  # @return [String]
  def brand_name
    brand_id ? brand.name : ''
  end
  # paginated results from the admin products grid
  #
  # @param [Optional params]
  # @param [Optional Boolean] the state of the product you are searching (active == true)
  # @return [ Array[Product] ]
  def self.admin_grid(params = {}, active_state = nil)

    params[:page] ||= 1
    params[:rows] ||= SETTINGS[:admin_grid_rows]

    grid = includes(:variants)#paginate({:page => params[:page]})
    grid = grid.where(['products.deleted_at IS NOT NULL AND products.deleted_at > ?', Time.now.to_s(:db)])  if active_state == false##  note nil != false
    grid = grid.where(['products.deleted_at IS NULL     OR  products.deleted_at < ?', Time.now.to_s(:db)])  if active_state == true
    grid = grid.where("products.name LIKE ?",                 "#{params[:name]}%")                  if params[:name].present?
    grid = grid.where("products.product_type_id = ?",      params[:product_type_id])       if params[:product_type_id].present?
    grid = grid.where("products.shipping_category_id = ?", params[:shipping_category_id])  if params[:shipping_category_id].present?
    grid = grid.where("products.available_at > ?",         params[:available_at_gt])       if params[:available_at_gt].present?
    grid = grid.where("products.available_at < ?",         params[:available_at_lt])       if params[:available_at_lt].present?
    grid = grid.where("products.active = ?",         params[:product_active])       if params[:product_active].present?
    grid
  end

  def create_original_variant(variant_attributes)
    property_size = Property.find_by_identifing_name('Size')
    variant = variants.create(name: 'Original', sku: "#{id}-Original", brand_id: brand.id, price: variant_attributes['price'], cost: variant_attributes['cost'])
    variant.variant_properties.create(property_id: property_size.id, description: "#{variant_attributes['size']['width']} x #{variant_attributes['size']['height']} #{variant_attributes['size']['measures']}")
    variant.inventory = Inventory.create(count_on_hand: 1)
  end
  
  def create_print_variant(variants_attributes)
    property_size = Property.find_by_identifing_name('Size')
    variants_attributes.each do |variant_attributes|
      variant = variants.create(name: 'Print', sku: "#{id}-Print", brand_id: brand.id)
      variant.variant_properties.create(property_id: property_size.id, description: "#{variant_attributes['size']['width']} x #{variant_attributes['size']['height']} #{variant_attributes['size']['measures']}")
      variant.inventory = Inventory.create
    end
  end
  
  def original_variant
    @original_variant ||= variants.where(name: 'Original').first
  end
  
  def print_variants
    #Postgresql
    #@print_variant ||= variants.where('variants.name iLike ?','%Print%')
    #Sqlite3
    @print_variant ||= variants.where('variants.name Like ?', '%Print%')
  end

  private
    def create_content
      require 'redcarpet/compat'

      description = self.description.to_s.gsub("\r", "<br>")
      description = description.gsub("\n", " ")
      description = description.gsub('"', "'")
      description = description.gsub("\"", "'")

      description_markup =  self.description_markup.to_s.gsub("\r", "<br>")
      description_markup =  description_markup.gsub("\n", " ")
      description_markup = description_markup.gsub('"', "'")
      description_markup = description_markup.gsub("\"", "'")

      if self.description_markup.present?
        #Checarlo correctamente que funcione el BlueCloth
        #self.description = BlueCloth.new(self.description_markup).to_html
        self.description = description
        self.description_markup = description
      elsif self.description.present?
        #Checarlo correctamente que funcione el BlueCloth
        #self.description_markup = BlueCloth.new(self.description).to_html
        self.description_markup = description
        self.description = description
      end
    end

    # if the permalink is not filled in set it equal to the name
    def sanitize_data
      self.permalink = name if permalink.blank? && name
      self.permalink = permalink.squeeze(" ").strip.gsub(' ', '-') if permalink
      if meta_keywords.blank? && description
        self.meta_keywords =  [name[0..55],
                              description.
                              gsub(/\d/, "").                 # remove non-alpha numeric
                              squeeze(" ").                   # remove extra whitespace
                              gsub(/<\/?[^>]*>/, "").         # remove hyper text
                              split(' ').                     # split into an array
                              map{|w| w.length > 2 ? w : ''}. # remove words less than 2 characters
                              join(' ').strip[0..198]         # join and limit to 198 characters
                              ].join(': ')
      end
      self.meta_description = [name[0..55], description.gsub(/<\/?[^>]*>/, "").squeeze(" ").strip[0..198]].join(': ') if name.present? && description.present? && meta_description.blank?
    end
end
