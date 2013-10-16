class Artwork::ProductTypesController < ApplicationController
  
  def new
    session[:new_artwork] = {}
    @product_types = ProductType.roots
  end
  
  def create
    session[:new_artwork][:product_type_id] = params[:product_type_id]
    redirect_to new_artwork_property_url
  end
end
