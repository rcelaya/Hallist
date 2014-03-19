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
      format.json { render json: {product_name: @product.name, collection_name: @collection.name, product_id: @product.id, collection_action: 'unhallit'} }
    end
  end
  
  def show
    @collection = CollectionDecorator.new(Collection.find(params[:id]))
  end

  def destroy
    product = Product.find(params[:id])
    collection = CartItem.find_by_user_id_and_variant_id(current_user.id,product.variants.first.id,:conditions => "cart_items.collection_id IS NOT NULL")
    collection.destroy
    flash[:notice] = 'Successfully destroyed collection.'
    render json: {product_name: product.name, product_id: product.id, collection_action: 'hallit'}
  end

  def delete_collection
    collection = Collection.find(params[:id])
    if collection.cart_items.present?
      collection.cart_items.each{|item|item.destroy}
    end
    collection.destroy
    redirect_to '/' + current_user.profile.username
  end
  
  private
  
  def set_filters
    params[:filters] = {} if params[:filters].nil?
    params[:filters][:search] = params[:search_term] if params[:search_term].present?
  end
end
