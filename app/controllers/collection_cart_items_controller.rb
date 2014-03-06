class CollectionCartItemsController < ApplicationController
  
  def create
    product = Product.find params[:product_id]
    if params[:collection_id].present?
      collection = Collection.find params[:collection_id]
      collection.create_item(product.variants.first)
    else
      
    end
    flash = {notice: 'Collection created successfully.'}
    #render json: [product, collection, product_id: product.id, collection_action: 'unhallit' ]
    respond_to do |format|
      format.html { redirect_to(:back, flash) }
      format.json { render json: {product_id: product.id, collection_action: 'unhallit'} }
    end
  end

  def destroy
    product = Product.find(params[:product_id])
    collection = CartItem.find_by_user_id_and_variant_id(current_user.id,product.variants.first.id,:conditions => "cart_items.collection_id IS NOT NULL")
    collection_id = collection.collection_id
    collection.destroy
    flash[:notice] = 'Successfully destroyed collection.'
    respond_to do |format|
      format.json { render json: {product_name: product.name, product_id: product.id, collection_action: 'hallit', collection_id: collection_id} }
      format.js
    end
  end
end
