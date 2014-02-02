class Artwork::VariantsController < ApplicationController
  def destroy
    @variant = Variant.find(params[:id])
    @cart_items = CartItem.find_by_variant_id(params[:id])
    @variant.destroy
    if @cart_items
      @cart_items.destroy
    end
    redirect_to :back
  end
end
