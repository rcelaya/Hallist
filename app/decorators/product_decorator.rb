class ProductDecorator < Draper::Base
  decorates :product
  include Draper::LazyHelpers
  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by including this module:
  #     include Draper::LazyHelpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):sfssfsf
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, attributes["created_at"].strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end
  
  def price
    h.number_to_currency price_range.last
  end
  
  def featured_image(image_size = :small, cache = true)
    images.order('created_at DESC').first ? images.order('created_at DESC').first.photo.url(image_size, cache) : "no_image_product.jpg" rescue "no_image_product.jpg"
  end
  
  def small_image
    featured_image(:small)
  end
  
  def detail_image
    featured_image(:large)
  end
  
  def small_image_height
    if product.respond_to?(:images)
      image = images.first
      if image
        proportion = ((220.00 * 100.00)/image.image_width.to_f)
        ((image.image_height * proportion)/100).round
      else
        '220'
      end
    end
  end
  
  def json_to_browse
    if(h.current_user.user)
      collection = h.current_user.user.cart_items.where('cart_items.collection_id IS NOT NULL AND cart_items.variant_id = ?', product.variants.first.id)
    end
    collection_action = (h.current_user.user && collection.present?) ? 'unhallit' : 'hallit'
    like_action = (h.current_user.user && h.current_user.user.likes?(product)) ? 'unlike' : 'like'
    if original_variant && original_variant.primary_property.nil?
      primary_property = original_variant.primary_property.description
    end

    if print_variants && print_variants.first && print_variants.first.primary_property.nil?
      primary_property = print_variants.first.primary_property.description
    end

    { id: product.id,
      name: product.name, 
      image: small_image, 
      price: price, 
      permalink: product.permalink, 
      brand_name: product.brand.name,
      brand_path: product.artist.profile_path,
      original_size: primary_property,
      image_height: small_image_height,
      like_action: like_action,
      product_type: product.product_type.name,
      collection_action: collection_action,
      variants: {
        original: {
          id: product.original_variant.present? ? product.original_variant.id : product.print_variants.first.id
        }
      }
    }
  end
  
  def json_to_details
    if(h.current_user.user)
      collection = h.current_user.user.cart_items.where('cart_items.collection_id IS NOT NULL AND cart_items.variant_id = ?', product.variants.first.id)
    end
    collection_action = (h.current_user.user && collection.present?) ? 'unhallit' : 'hallit'
    like_action = (h.current_user.user && h.current_user.user.likes?(product)) ? 'unlike' : 'like'
    variants = product.original_variant.present? ?  {original: { price: h.number_to_currency(product.original_variant.price),size: product.original_variant.primary_property.description,id: product.original_variant.id,amount_inventory: product.original_variant.inventory.count_on_hand},prints: product.print_variants.collect {|print| {id: print.id,name: print.name,size: print.primary_property.description,price: h.number_to_currency(print.price),amount_inventory: print.inventory.count_on_hand}}} : {prints: product.print_variants.collect {|print| {id: print.id,name: print.name,size: print.primary_property.description,price: h.number_to_currency(print.price),amount_inventory: print.inventory.count_on_hand}}}
    { id: product.id,
      name: product.name, 
      image: detail_image,
      small_image: small_image,
      price: price, 
      permalink: product.permalink,
      product_type: product.product_type.name,
      like_action: like_action,
      collection_action: collection_action,
      artist_avatar: product.artist.featured_avatar,
      artist_id: product.artist.id,
      brand_name: product.brand.name,
      brand_path: product.artist.profile_path,
      following: (h.current_user.user && h.current_user.follows?(product.artist.user)),
      description: product.description,
      height: product.original_variant.present? ? product.original_variant.size['height'] : product.print_variants.first.size['height'],
      width: product.original_variant.present? ? product.original_variant.size['width'] : product.print_variants.first.size['width'],
      measures: product.original_variant.present? ? product.original_variant.size['measures'] : product.print_variants.first.size['measures'],
      variants: variants,
      auction: {
        id: product.auction.try(:id),
        minimun_bid: product.auction.try(:minimum_bid),
        deadline: product.auction.present? ? h.distance_of_time_in_words(Time.now, product.auction.deadline) : nil,
        bids_count: product.auction.try(:bids).try(:count),
        active: (product.auction.present? ? product.auction.active : false),
        open: (product.auction.present? ? product.auction.open? : false),
        your_bids: (h.current_user.user.present? && product.auction.present?) ? h.current_user.user.bids.where(auction_id: product.auction.id).map(&:amount) : []
      }
    }
  end
  
end
