module Artwork::ProductsHelper
  def show_sidebar?
    params[:product_type_id].blank?
  end
  
  def browse_title
    @product_type.present? ? @product_type.name : 'Browse'
  end
end
