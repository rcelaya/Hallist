class CollectionsController < ApplicationController
  def index
    set_filters
    search = Collection.filters(params[:filters] || {}, params[:page])
    @collections = CollectionDecorator.decorate(search.results).map &:json_to_browse
    respond_to do |format|
      format.html
      format.json { render json: @collections }
    end
  end
  
  def create
    @collection = current_user.collections.new params[:collection]
    if @collection.save
      if params[:product_id]
        @product = Product.find params[:product_id]
        @collection.create_item(@product.variants.first)
      end
      flash = {notice: 'Collection created successfully.'}
    else
      flash = {error: 'Could not create the collection.'}
    end
    respond_to do |format|
      format.html { redirect_to(:back, flash) }
      format.json { render json: {product_name: @product.name, collection_name: @collection.name} }
    end
  end
  
  def show
    @collection = CollectionDecorator.new(Collection.find(params[:id]))
  end
  
  private
  
  def set_filters
    params[:filters] = {} if params[:filters].nil?
    params[:filters][:search] = params[:search_term] if params[:search_term].present?
  end
end
