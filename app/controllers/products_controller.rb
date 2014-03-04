class ProductsController < ApplicationController

  def index
    set_filters
    #puts 'filtros' + params[:filters].to_yaml
    #current_user = current_user
    search = Product.filters(params[:filters] || {}, params[:page])
    @products = ProductDecorator.decorate(search.results).map(&:json_to_browse)
    @featured_product = ProductDecorator.decorate(Product.featured) unless request.xhr?
    @notices = Notice.active unless request.xhr?
    respond_to do |format|
      format.html do
        #redirect_to artwork_url(search.results.first.permalink) if @products.size == 1
      end
      format.json { render json: @products }
      format.js
    end
  end

  def create
    pagination_args = {}
    pagination_args[:page] = params[:page] || 1
    pagination_args[:rows] = params[:rows] || 15

    if params[:q] && params[:q].present?
      @products = Product.standard_search(params[:q], pagination_args).results
    else
      @products = Product.where('deleted_at IS NULL OR deleted_at > ?', Time.zone.now )
    end

    render :template => '/products/index'
  end

  def show
    @product = ProductDecorator.decorate(Product.active.find(params[:id]))
    fbgraph_object
    form_info
    #puts @product.json_to_details.to_yaml
    respond_to do |format|
      format.html {render :index}
      format.json { render json: @product.json_to_details }
    end
  end

  private

  def form_info
    @cart_item = CartItem.new
  end

  def featured_product_types
    [ProductType::FEATURED_TYPE_ID]
  end

  def fbgraph_object
    # TO-DO: This looks unused. Check
    @fbgraph_object = {app_id: FACEBOOK_KEY, type: "hallist:artwork", url: request.url, title: @product.name, image: @product.small_image}
  end

  def set_filters
    params[:filters] = {} if params[:filters].nil?
    params[:filters][:property_values_id] = params[:property_values_id] if params[:property_values_id].present?
    params[:filters][:product_type_id] = params[:product_type_id] if params[:product_type_id].present?
    params[:filters][:price] = {} if params[:price_from].present? or params[:price_to].present?
    params[:filters][:price][:from] = params[:price_from] if params[:price_from].present?
    params[:filters][:price][:to] = params[:price_to] if params[:price_to].present?
    params[:filters][:search] = params[:search_term] if params[:search_term].present?
  end
end

