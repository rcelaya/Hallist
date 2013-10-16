namespace :db do
  task :seed_fake => :environment do
    if defined?(Product.solr_search)
      begin
        Rake::Task["sunspot:solr:start"].invoke
      rescue Exception => e
        puts e
      end
    end

    file_to_load        = Rails.root + "db/seed/config_admin.yml"
    config_information  = YAML::load( File.open( file_to_load ) )
    unless Brand.first
      if Role.first
        config_information.each do |table|
          #puts table[0].singularize.camelcase
          tables_model = table[0].singularize.camelcase.constantize
          table[1].each_pair do |num, attribute_hash|
            puts [num, tables_model.to_s].join(' | ')
            tables_model.create( attribute_hash['attributes'])
          end
        end
      else
        puts 'PLEASE RUN "rake db:seed" before running "rake db:seed_fake"'
      end
    else
      puts 'IT APPEAR YOU ALREADY HAVE DATA. PLEASE truncate your DB or take a look because it might be ready to go!!'
    end
  end
  
  desc "Charge the seeds to arto online store"
  task :arto_seed => [:environment] do
    #Shipping Methods
    ShippingMethod.create(name: 'UPS 3-5 day',  shipping_zone_id: 1)
    ShippingMethod.create(name: 'UPS next day', shipping_zone_id: 1)
    ShippingMethod.create(name: 'UPS 3-5 day',  shipping_zone_id: 2)
    ShippingMethod.create(name: 'UPS 3-5 day',  shipping_zone_id: 3)
    ShippingMethod.create(name: 'UPS 7-14 day', shipping_zone_id: 3)
    ShippingMethod.create(name: 'UPS 7-14 day', shipping_zone_id: 4)
    
    # Shipping Categories
    ShippingCategory.create(name: 'Regular')
    
    #Shipping Rates
    ShippingRate.create(shipping_method_id: 1,
          rate: '0.00',
          shipping_rate_type_id: 2,
          shipping_category_id: 1,
          minimum_charge: '25.00',
          position: 1,
          active: true)
    ShippingRate.create(shipping_method_id: 1,
          rate: '7.00',
          shipping_rate_type_id: 2,
          shipping_category_id: 1,
          minimum_charge: '0.00',
          position: 2,
          active: true)
    ShippingRate.create(shipping_method_id: 2,
          rate: '15.00',
          shipping_rate_type_id: 2,
          shipping_category_id: 1,
          minimum_charge: '0.00',
          position: 3,
          active: true)
    ShippingRate.create(shipping_method_id: 2,
          rate: '15.00',
          shipping_rate_type_id: 2,
          shipping_category_id: 1,
          minimum_charge: '0.00',
          position: 3,
          active: true)
    ShippingRate.create(shipping_method_id: 3,
          rate: '10.00',
          shipping_rate_type_id: 2,
          shipping_category_id: 1,
          minimum_charge: '0.00',
          position: 1,
          active: true)
    ShippingRate.create(shipping_method_id: 4,
          rate: '15.00',
          shipping_rate_type_id: 2,
          shipping_category_id: 1,
          minimum_charge: '0.00',
          position: 1,
          active: true)
    ShippingRate.create(shipping_method_id: 5,
          rate: '10.00',
          shipping_rate_type_id: 2,
          shipping_category_id: 1,
          minimum_charge: '0.00',
          position: 2,
          active: true)
    ShippingRate.create(shipping_method_id: 6,
          rate: '12.00',
          shipping_rate_type_id: 2,
          shipping_category_id: 1,
          minimum_charge: '0.00',
          position: 2,
          active: true)

    #Properties
    property_001 = Property.create(identifing_name: 'Color', display_name: 'Color')
    property_002 = Property.create(identifing_name: 'Size', display_name: 'Size')
    
    # Property Values
    PropertyValue.create(name: 'White', property_id: property_001.id)
    PropertyValue.create(name: 'Black', property_id: property_001.id)
    PropertyValue.create(name: 'Blue', property_id: property_001.id)
    PropertyValue.create(name: 'Red', property_id: property_001.id)
    PropertyValue.create(name: 'Yellow', property_id: property_001.id)
    PropertyValue.create(name: 'Orange', property_id: property_001.id)
    PropertyValue.create(name: 'Green', property_id: property_001.id)
    PropertyValue.create(name: 'Pink', property_id: property_001.id)
    PropertyValue.create(name: 'Brown', property_id: property_001.id)
    PropertyValue.create(name: 'Gray', property_id: property_001.id)
    PropertyValue.create(name: 'Violet', property_id: property_001.id)
    
    
    #Product Types
    product_types_root_1 = ProductType.create(name: "Art")
    ProductType.create(name: "Oil Painting", parent_id: product_types_root_1.id)
    ProductType.create(name: "Acrylic Painting", parent_id: product_types_root_1.id)
    ProductType.create(name: "Mixed Media", parent_id: product_types_root_1.id)
    ProductType.create(name: "Collage", parent_id: product_types_root_1.id)
    ProductType.create(name: "Illustration", parent_id: product_types_root_1.id)
    ProductType.create(name: "Watercolor Painting", parent_id: product_types_root_1.id)
    ProductType.create(name: "Photography", parent_id: product_types_root_1.id)
    ProductType.create(name: "Prints", parent_id: product_types_root_1.id)
    ProductType.create(name: "Drawings", parent_id: product_types_root_1.id)
    ProductType.create(name: "Street Art", parent_id: product_types_root_1.id)
    ProductType.create(name: "Sculpture", parent_id: product_types_root_1.id)
    product_types_root_2 = ProductType.create(name: "Industrial Design")
    ProductType.create(name: "Sculpture", parent_id: product_types_root_2.id)
    ProductType.create(name: "Chairs", parent_id: product_types_root_2.id)
    ProductType.create(name: "Tables", parent_id: product_types_root_2.id)
    ProductType.create(name: "Lamps", parent_id: product_types_root_2.id)
    ProductType.create(name: "Bureaus", parent_id: product_types_root_2.id)
    ProductType.create(name: "Jewellery", parent_id: product_types_root_2.id)
    ProductType.create(name: "Vintage", parent_id: product_types_root_2.id)
    product_types_root_3 = ProductType.create(name: "Fashion Design")
    product_types_sub_1 = ProductType.create(name: "Men", parent_id: product_types_root_3.id)
    ProductType.create(name: "Shirts", parent_id: product_types_sub_1.id)
    ProductType.create(name: "T-Shirts", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Sweatshirts", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Jackets", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Coats", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Pants", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Hats", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Shoes", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Watches", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Eyewear", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Accessories", parent_id: product_types_sub_1.id)
    ProductType.create(name: "Vintage", parent_id: product_types_sub_1.id)
    product_types_sub_2 = ProductType.create(name: "Women", parent_id: product_types_root_3.id)
    ProductType.create(name: "Shirts", parent_id: product_types_sub_2.id)
    ProductType.create(name: "T-Shirts", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Sweatshirts", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Jackets", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Coats", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Pants", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Skirts", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Hats", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Shoes", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Watches", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Eyewear", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Bags & Purses", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Accessories", parent_id: product_types_sub_2.id)
    ProductType.create(name: "Vintage", parent_id: product_types_sub_2.id)
    
    # Tax Categories
    TaxCategory.create(name: 'Standard')
    
    ItemType.create(name: 'collection')

  end
  
  
  desc "Task description"
  task :create_artist => [:environment] do
    (1..5).each do
      user_artist = User.create(
          email: Faker::Internet::email, 
          password: 'Passw0rd', 
          password_confirmation: 'Passw0rd', 
          first_name: Faker::Name::first_name, 
          last_name: Faker::Name::last_name, 
          artist: true, 
          enable_to_sell: true,
          profile_attributes: {
            username: Faker::Internet::user_name
          }
      )
    end
  end
  
  desc "Task description"
  task :create_users => [:environment] do
    (1..5).each do
      user_artist = User.create(
          email: Faker::Internet::email, 
          password: 'Passw0rd', 
          password_confirmation: 'Passw0rd', 
          first_name: Faker::Name::first_name, 
          last_name: Faker::Name::last_name, 
          profile_attributes: {
            username: Faker::Internet::user_name
          }
      )
    end
  end
  
  desc "Task description"
  task :create_products => [:environment] do
    # Users
    # user_admin = User.create(email: 'arto@parbros.com', password: 'Passw0rd', password_confirmation: 'Passw0rd', first_name: 'Arto', last_name: 'Gallery')
    # user_admin.roles = [Role.first]
    # user_admin.save

    property_size = Property.find_by_identifing_name('Size')
    
    puts "Creating products"
    (1..100).each do
      product_name = Faker::Product::product_name
      permalink = product_name.downcase.gsub(' ', '-')
      user_artist = User.where(artist: true).first(:order => "RANDOM()")
      description = Faker::Lorem::sentence
      
      product = Product.create(name: product_name, permalink: permalink, product_type_id: 2, description_markup: description, shipping_category_id: 1, tax_category_id: 1, brand_id: user_artist.brand.id, product_properties_attributes: [{property_id: 1, description: ""}], property_value_ids: [1,2], active: true, meta_keywords: product_name.downcase, meta_description: product_name.downcase)
      
      price = rand(3000)
      puts "Creating variants"
      if product.persisted?
        product_original_variant = product.variants.create(name: 'Original', sku: "#{product.id}-Original", brand_id: user_artist.brand.id, price: price)
        product_original_variant.inventory.update_attribute(:count_on_hand, 1)
        product_original_variant.variant_properties.create(property_id: property_size.id, description: "#{rand(50)} x #{rand(35)}")


        (1..(rand(5))).each do |print_index|
          product_print_variant = product.variants.create(name: 'Print 00#{print_index}', sku: "#{product.id}-Print-00#{print_index}", brand_id: user_artist.brand.id, price: rand((price*0.6)))
          product_print_variant.variant_properties.create(property_id: property_size.id, description: "#{rand(30)} x #{rand(20)}")
        end

        product.images.create(photo: File.open("docs/samples/artwork-0#{"%02d" % rand(34)}.jpg"))
      end
    end
  end
  
  desc "Task description"
  task :create_collections => [:environment] do
    (1..100).each do
      user = User.first(:order => "RANDOM()")
      collection = user.collections.create(name: Faker::Product::product_name, description: Faker::Lorem::sentence, private: false)
      
      (2..(rand(15))).each do |print_index|
        product = Product.where(active: true).first(:order => "RANDOM()")
        collection.create_item(product.variants.first)
      end
    end
  end
  
  desc "Task description"
  task :heroku_reset => [:environment] do
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["db:arto_seed"].invoke
    Rake::Task["db:create_artist"].invoke
    Rake::Task["db:create_users"].invoke
    Rake::Task["db:create_products"].invoke
    Rake::Task["db:create_collections"].invoke
  end
  
  desc "Task description"
  task :fake_reset_arto => [:environment] do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:heroku_reset"].invoke
  end
end
