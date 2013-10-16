class Products::LikesController < ApplicationController
  
  def create
    @product = Product.find params[:product_id]
    current_user.like! @product
    render json: {product_name: @product.name, product_id: @product.id, like_action: 'unlike'}
  end

  def destroy
    @product = Product.find params[:product_id]
    current_user.unlike! @product
    render json: {product_name: @product.name, product_id: @product.id, like_action: 'like'}
  end

end
