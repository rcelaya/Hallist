class Profiles::ProductsController < ApplicationController
  
  def index
    profile = Profile.find(params[:profile_id])
    user = profile.user
    products = user.brand.products.page(params[:page]).per_page(9)
    products = ProductDecorator.decorate(products).map(&:json_to_browse)
    respond_to do |format|
      format.json { render json: products }
    end
  end
end
