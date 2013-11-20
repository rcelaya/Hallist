class Artwork::ProductsController < ApplicationController
  before_filter :clean_params, only: [:create, :update]

  layout 'no-responsive'

  def new
    @product = Product.new(session[:new_artwork])
    puts "producto para vista" + @product.to_yaml
    @colors = Property.find_by_identifing_name('Color').property_values.collect {|color| [color.name, color.id]}
  end
  
  def create
    @product = Product.new(params[:product])
    @product.brand = current_user.brand
    @product.shipping_category = ShippingCategory.find_by_name 'Regular'
    @product.tax_category = TaxCategory.find_by_name 'Standard'
    @product.permalink = @product.name.parameterize
    if @product.save
      @product = Product.find_by_name(@product.name)
      @variant_original = Variant.find_by_product_id_and_name(@product.id, "Original")
      @variant_original.sku = @product.id.to_s+"-Original"
      @variant_original.save
      @variant_print = Variant.find_by_product_id_and_name(@product.id, "Print")
      if !@variant_print.nil?
        @variant_print.sku = @product.id.to_s+"-Print"
        @variant_print.save
      end
      redirect_to artwork_dashboard_url
    else
      @colors = Property.find_by_identifing_name('Color').property_values.collect {|color| [color.name, color.id]}
      render :new
    end
  end
  
  def edit
    @product = Product.find params[:id]
    puts 'editarrrrrrrr producttt' + @product.to_yaml
    @colors = Property.find_by_identifing_name('Color').property_values.collect {|color| [color.name, color.id]}
  end
  
  def update
    @product = Product.find params[:id]
    puts 'update params' + @product.to_yaml
    if @product.update_attributes params[:product]
      redirect_to artwork_dashboard_url
    else
       @colors = Property.find_by_identifing_name('Color').property_values.collect {|color| [color.name, color.id]}
      render :edit
    end
  end
  
  def show
    @product = Product.find params[:id]
  end
  
  private
  
  def clean_params
    params[:product].delete(:auction_attributes) unless params[:artwork_auction].present?
  end
end
