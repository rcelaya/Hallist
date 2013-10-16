class Artwork::PropertiesController < ApplicationController
  
  def new
    @colors = Property.find_by_identifing_name('color').property_values.collect {|color| [color.name, color.id]}
  end
  
  def create
    session[:new_artwork][:property_value_ids] = params[:property_value_ids]
    redirect_to new_artwork_product_url
  end

end
