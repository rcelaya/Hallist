class CollectionCartItemsController < ApplicationController
  
  def create
    product = Product.find params[:product_id]
    if params[:collection_id].present?
      collection = Collection.find params[:collection_id]
      collection.create_item(product.variants.first)
    else
      
    end
    render json: [product, collection]
  end
end
